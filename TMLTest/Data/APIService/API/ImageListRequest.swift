//
//  ImageListRequest.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Foundation

class ImageListRequest: APIRequestType {
    
    typealias Response = ImageList
    
    var path: String = "/v2/list"

    var params: [String: Any] = [:]
    
    var method: APIMethod = .get
}
