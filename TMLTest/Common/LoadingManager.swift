//
//  LoadingManager.swift
//  CombineTest
//
//  Created by jieyong looi on 22/07/2021.
//

import UIKit

class LoadingManager {
    static let shared = LoadingManager()
    private var loadingView: LoadingView?
    
    func show() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.loadingView?.removeFromSuperview()
                self.loadingView = LoadingView(frame: window.bounds )
                window.addSubview(self.loadingView ?? LoadingView())
            }
        }
    }
    
    func hide() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.loadingView?.removeFromSuperview()
        }
    }
}
