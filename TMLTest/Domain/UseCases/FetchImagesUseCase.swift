//
//  FetchImagesUseCase.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Foundation
import Combine

protocol FetchImagesUseCase {
    func execute(request: ImageListRequest, completion: @escaping (ImageList) -> Void)
}

final class FetchImageListUseCase: FetchImagesUseCase {

    @Injected(\.imagesRepo) var imagesRepo: ImagesRepo
    private var cancellables: [AnyCancellable] = []
//    private let imagesRepo: ImagesRepo
    
//    init(repo: ImageListRepo = ImageListRepo()) {
//        self.imagesRepo = repo
//    }
    
    func execute(request: ImageListRequest, completion: @escaping (ImageList) -> Void) {
        self.imagesRepo.fetchImageList(request: request, completion: { [weak self] list in
            guard self != nil else { return }
            completion(list)
        })
    }
}
