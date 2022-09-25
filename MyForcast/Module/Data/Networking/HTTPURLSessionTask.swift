//
//  HTTPURLSessionTask.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import Foundation

class HTTPURLSessionTask: HTTPSessionTask {
    private let sessionDataTask: URLSessionDataTask
    
    init(_ sessionDataTask: URLSessionDataTask) {
        self.sessionDataTask = sessionDataTask
    }
    
    func resume() {
        sessionDataTask.resume()
    }
}
