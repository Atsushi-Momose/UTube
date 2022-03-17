//
//  UTubePresenter.swift
//  UTube
//
//  Created by 百瀬篤志 on 2022/03/15.
//

import Foundation

protocol UTubePresentation {
    func textFieldDidChanged(searchWord: String)
}

class UtubePresenter {
    
    private var interactor: UTubeUsecase
    var searchedItems: [UTubeEntity]
    
    init(interactor: UTubeUsecase) {
        self.interactor = interactor
        self.searchedItems = [UTubeEntity]()
        
        // 検索完了通知受け取り
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: .textSearchDidEnd, object: nil)
    }
}

extension UtubePresenter: UTubePresentation {
    
    func textFieldDidChanged(searchWord: String) {
        self.searchParameter(param: searchWord)
        
        // viewにインジケーター表示の通知を送る
    }
    
    private func searchParameter(param: String) {
        self.interactor.getSearchParam(param: param)
    }
    
    @objc private func reload(notification: NSNotification?) {
        let data = notification?.userInfo!["items"]
        // ContentViewに通知
        NotificationCenter.default.post(name: .textSearchDidEnd, object: nil, userInfo: ["items": [data]])

        print("")
    }
}

extension Notification.Name {
    static let reloadData = Notification.Name("reloadData")
}
