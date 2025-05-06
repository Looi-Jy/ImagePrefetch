//
//  ImagesRepo.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Foundation

protocol ImagesRepo {
    func fetchImageList(request: ImageListRequest, completion: @escaping (ImageList) -> Void)
}
