//
//  ImageListRepo.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Foundation
import Combine

final class ImageListRepo {
    
    @Injected(\.apiService) var apiService: APIServiceType
    private var cancellables: [AnyCancellable] = []
//    private let apiService: APIServiceType
//    let imageListSubject = PassthroughSubject<ImageList, Never>()
    
//    init(apiService: APIService = APIService()) {
//        self.apiService = apiService
//    }
}

extension ImageListRepo: ImagesRepo, MsgHelper {
    
    func fetchImageList(request: ImageListRequest, completion: @escaping (ImageList) -> Void) {
        
        self.apiService.response(from: request)
            .catch { [weak self] error -> Empty<ImageList, Never> in
                self?.showError(error: error)
                return .init()
            }
            .sink(receiveValue: { [weak self] data in
                guard self != nil else { return }
                completion(data)
            })
            .store(in: &self.cancellables)
    }
}
