//
//  ImagesRepoKey.swift
//  TMLTest
//
//  Created by JY Looi on 6/7/22.
//

import Foundation

private struct ImagesRepoKey: InjectionKey {
    static var currentValue: ImagesRepo = ImageListRepo()
}

extension InjectedValues {
    var imagesRepo: ImagesRepo {
        get { Self[ImagesRepoKey.self] }
        set { Self[ImagesRepoKey.self] = newValue }
    }
}
