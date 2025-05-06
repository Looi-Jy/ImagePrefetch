//
//  MsgHelper.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Foundation

protocol MsgHelper {}

extension MsgHelper {
    func showError(error: APIServiceError, msg: String = "", path: String = "", duration: TimeInterval = 1.5) {
        var msg:String = msg
        switch error {
        case .responseError:
            msg = "Network Error"
        case .parseError:
            msg = "Parse Error"
        default:
            break
        }
        MsgManager.shared.show(msg: msg, duration: duration)
    }
}
