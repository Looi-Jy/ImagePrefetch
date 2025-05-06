//
//  ApiLoading.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Combine

final class ApiLoading {
    @Published
    var loading: Bool = false
    
    init(loading: Bool) {
        self.loading = loading
    }
}
