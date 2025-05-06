//
//  FetchImagesUseCase.swift
//  TMLTest
//
//  Created by JY Looi on 6/7/22.
//

import Foundation

private struct FetchImagesUseCaseKey: InjectionKey {
    static var currentValue: FetchImagesUseCase = FetchImageListUseCase()
}

extension InjectedValues {
    var fetchImagesUsecase: FetchImagesUseCase {
        get { Self[FetchImagesUseCaseKey.self] }
        set { Self[FetchImagesUseCaseKey.self] = newValue }
    }
}
