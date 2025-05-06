//
//  APIServiceError.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Foundation

enum APIServiceError: Error {
    case responseError
    case parseError(Error)
    case apiError
}
