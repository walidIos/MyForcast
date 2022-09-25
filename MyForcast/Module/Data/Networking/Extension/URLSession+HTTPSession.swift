//
//  URLSession+HTTPSession.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import Foundation

extension URLSession: HTTPSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask {
        return HTTPURLSessionTask(URLSession.shared.dataTask(with: request, completionHandler: completionHandler))
    }
}
