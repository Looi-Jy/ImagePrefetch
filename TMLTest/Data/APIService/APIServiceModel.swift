//
//  APIServiceModel.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Foundation

enum APIMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIEncoding {
    case url
    case json
//    case multipart
}

protocol APIRequestType {
    associatedtype Response: Decodable
    
    var path: String { get }
    var params: [String: Any] { get }
    var method: APIMethod { get }
    
}

extension APIRequestType {
    
    func getQueryItems() -> [URLQueryItem]? {
        return self.params.map {
            URLQueryItem(name: $0.0, value: $0.1 as? String)
        }
    }
}
