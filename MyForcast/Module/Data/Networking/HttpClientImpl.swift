//
//  HttpClientImpl.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import Foundation

protocol HttpClient {
    func request<T: Decodable>(_ request: ApiRequest, completion: @escaping (Result<T, ApiError>) -> Void)
}

class HttpClientImpl: HttpClient {
    
    private let httpSession: HTTPSession
    
    init(httpSession: HTTPSession) {
        self.httpSession = httpSession
    }
    
    func request<T>(_ request: ApiRequest, completion: @escaping (Result<T, ApiError>) -> Void) where T : Decodable {
        var urlRequest = URLRequest(url: request.resource)
        var headers = request.header
        urlRequest.timeoutInterval = 60
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = request.method.rawValue
        urlRequest = self.buildGetRequest(path: request.resource.absoluteString, params: request.params!)!
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        ///performs request
        let task = httpSession.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completion(.failure(ApiError.requestFailed(error: "\(error?.localizedDescription ?? "ERROR")")))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.nonHTTPResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            switch response.statusCode {
            case 200..<300:
                var json: T?
                do {
                    json = try JSONDecoder().decode(T.self, from: data)
                } catch let error {
                    debugPrint(error)
                    completion(.failure(ApiError.serializationError))
                    return
                }
                if let jsonData = json {
                    completion(.success(jsonData))
                } else {
                    completion(.failure(ApiError.serializationError))
                }
                return
            case 401 :
                completion(.failure(ApiError.serverError))
                return
            case 402..<500 :
                completion(.failure(ApiError.clientError))
                return
            case 500..<600:
                completion(.failure(ApiError.serverError))
                return
            default :
                completion(.failure(ApiError.undefined))
                return
            }
        }
        task.resume()
    }
    
  
    private func buildGetRequest(path: String,
                                 params: [String: Any]) -> URLRequest? {
        let component = self.getComponentsParams(url: path, params: params)
        guard let url = component?.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    func getComponentsParams(url: String,
                             params: [String: Any]) -> URLComponents? {
        guard var component = URLComponents(string: url) else {
            return nil
        }
        component.queryItems = params.map({ key, value in
            return URLQueryItem(name: key, value: value as? String ?? "")
        })
        component.percentEncodedQuery = component.percentEncodedQuery?.replacingOccurrences(of: "+",
                                                                                            with: "%2B")
        return component
    }
    
}
