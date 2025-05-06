//
//  ImageListViewModel.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Foundation
import Combine

final class ImageListViewModel: BaseViewModel, ObservableObject {
    
    @Injected(\.fetchImagesUsecase) var getImageListUsecase: FetchImagesUseCase
    
    private lazy var request: ImageListRequest = {
        return ImageListRequest()
    }()
     
    private let apiLoading: ApiLoading = ApiLoading(loading: false)
//    private lazy var getImageListUsecase: FetchImageListUseCase = {
//        return FetchImageListUseCase()
//    }()
        
//    // MARK: Input

    enum Input {
        case getImageList
        case getMoreData
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .getImageList:
            self.page = 1
            self.isNotFirstPage = false
        case .getMoreData:
//            if !self.isValidPage() {
//                return
//            }
            self.page += 1
            self.isNotFirstPage = true
        }
        self.request.params = ["page": "\(self.page)", "limit": "\(self.limit)"]
        self.getImageList()
    }
    
//    // MARK: Output
    @Published private(set) var imageList: [ImageData] = []
    let responseSubject = PassthroughSubject<ImageList, Never>()

    private lazy var apiService: APIService = {
        return APIService()
    }()

    override init() {
        super.init()
        
        self.bindInputs()
        self.bindOutputs()
    }
    
    private func getImageList() {
        self.apiLoading.loading = true
        self.getImageListUsecase.execute(request: self.request, completion: { [weak self] data in
            guard let `self` = self else { return }
            self.apiLoading.loading = false
            self.responseSubject.send(data)
        })
    }

    private func bindInputs() {
        self.bindTableLoading(loading: self.apiLoading)
    }
    
    private func bindOutputs() {
        self.responseSubject
            .map {
                if self.isNotFirstPage {
                    let new: [ImageData] = $0.data ?? []
                    if new.isEmpty { self.page -= 1 }
                    self.imageList += new
                }else {
                    self.imageList = $0.data ?? []
                }
                return self.imageList
            }
            .assign(to: \.self.imageList, on: self)
            .store(in: &self.cancellables)

    }
    
}
