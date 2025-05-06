//
//  MsgManager.swift
//  CombineTest
//
//  Created by jieyong looi on 23/07/2021.
//

import UIKit

class MsgManager {
    
    static let shared = MsgManager()
//    private var msgView: MsgView?
    
    func show(msg: String, duration: TimeInterval = 1.5) {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) {
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                let msgView: MsgView = MsgView(frame: window.bounds, msg: msg)
                window.addSubview(msgView)
                
                if duration > 0 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: { [weak self] in
                        guard self != nil else { return }
                        msgView.removeFromSuperview()
                    })
                }
            }
        }
    }
    
}
