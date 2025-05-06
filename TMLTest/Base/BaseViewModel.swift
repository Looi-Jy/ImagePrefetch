//
//  BaseViewModel.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Foundation
import Combine
import KafkaRefresh

class BaseViewModel {
    @Published var loading: Bool = false
    @Published var headLoading: Bool = false
    @Published var footLoading: Bool = false
    var cancellables: [AnyCancellable] = []
    var page: Int = 1
    var limit: Int = 20
    var totalPage: Int = 1
    var isNotFirstPage: Bool = false
    private var retryTrigger = PassthroughSubject<Void, Never>()
    
    init() {
        self.$loading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                guard self != nil else { return }
                if isLoading {
                    LoadingManager.shared.show()
                }else {
                    LoadingManager.shared.hide()
                }
            })
            .store(in: &self.cancellables)
        
    }
    
    
    func isValidPage() -> Bool {
        if self.page < self.totalPage {
            return true
        }
        self.footLoading = false
        return false
    }
    
}


// MARK: Bindings
extension BaseViewModel {
    
    func bindHeaderRefreshCtrl(_ ctrl: KafkaRefreshControl) {
        self.$headLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                guard self != nil else { return }
                if isLoading {
                    ctrl.beginRefreshing()
                }else {
                    ctrl.endRefreshing()
                }
            })
            .store(in: &self.cancellables)
    }
    
    func bindFooterRefreshCtrl(_ ctrl: KafkaRefreshControl) {
        self.$footLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                guard self != nil else { return }
                if isLoading {
                    ctrl.beginRefreshing()
                }else {
                    ctrl.endRefreshing()
                }
            })
            .store(in: &cancellables)
    }
    
    func bindLoading(loading: ApiLoading) {
        loading.$loading
        .receive(on: DispatchQueue.main)
        .assign(to: \.self.loading, on: self)
        .store(in: &self.cancellables)
    }
    
    func bindTableLoading(loading: ApiLoading) {
        loading.$loading
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] loading in
            guard let `self` = self else { return }
            
            if self.isNotFirstPage {
                self.footLoading = loading
            }else {
                self.headLoading = loading
            }
            
        })
        .store(in: &self.cancellables)
    }
    
}
