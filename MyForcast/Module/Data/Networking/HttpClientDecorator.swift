//
//  HttpClientDecorator.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import Foundation

class HttpClientDecorator: HttpClient {
    
    private let decoratee: HttpClient
    private var reachability: Reachability?
    
    init(_ decoratee: HttpClient) {
        self.decoratee = decoratee
        reachability = try? Reachability()
    }
    
    /// Decorate request call by networking check
    /// - Parameters:
    ///   - request: HttpClient call input
    ///   - completion: result callback
    
    func request<T>(_ request: ApiRequest, completion: @escaping (Result<T, ApiError>) -> Void) where T : Decodable {
        if reachability?.connection == Reachability.Connection.unavailable {
            completion(.failure(ApiError.internetError))
        } else {
            Utilities.guaranteeMainThread {
                self.decoratee.request(request, completion: completion)
            }
        }
    }
    
    
}

enum Utilities {
    static func guaranteeMainThread(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}
