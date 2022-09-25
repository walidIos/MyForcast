//
//  ApiRequest.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import Foundation

class ApiRequest {
    
    let resource: URL
    let method: HttpMethod
    let header: [String: String]?
    let params: [String: Any]?
    let protected: Bool
    
    init(resource: URL,
         method: HttpMethod = .get,
         header: [String: String]? = nil,
         params: [String: Any]? = nil,
         protected: Bool = true) {
        
        self.resource = resource
        self.method = method
        self.header = header
        self.params = params
        self.protected = protected
    }
}
