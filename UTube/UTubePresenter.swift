//
//  UTubePresenter.swift
//  UTube
//
//  Created by 百瀬篤志 on 2022/03/15.
//

import Foundation
import Combine

protocol UTubePresentation {
    func textFieldDidChanged(searchWord: String)
}

class UtubePresenter : ObservableObject {
    
    @Published var searchedItems: UTubeEntity
    private var interactor: UTubeUsecase
    private var cancellables = [AnyCancellable]()
    
    init(interactor: UTubeInteractor) {
        self.interactor = interactor
        self.searchedItems = UTubeEntity()
        
        // UTubeInteractorから通知を受け取り自身のsearchedItemsを上書き
        self.interactor.listPublisher()
            .sink(receiveCompletion: { print ("completion: \($0)") },
                  receiveValue: { value in self.searchedItems = value}) // receiveValue: { print ("value: \($0)") })
            .store(in: &cancellables)
        
        self.searchParameter(param: "")
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
}
