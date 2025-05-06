//
//  ImageData.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Foundation

struct ImageList: Codable {
    let data: [ImageData]?
}

struct ImageData: Codable, Hashable {
    let id: String?
    let author: String?
    let width: Int?
    let height: Int?
    let url: String?
    let downloadUrl: String?
    
}
