//
//  APIServiceKey.swift
//  TMLTest
//
//  Created by JY Looi on 6/7/22.
//

import Foundation

private struct APIServiceKey: InjectionKey {
    static var currentValue: APIServiceType = APIService()
}

extension InjectedValues {
    var apiService: APIServiceType {
        get { Self[APIServiceKey.self] }
        set { Self[APIServiceKey.self] = newValue }
    }
}
