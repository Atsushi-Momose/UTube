//
//  UTubeInteractor.swift
//  UTube
//
//  Created by 百瀬篤志 on 2022/03/15.
//

import Foundation
import Alamofire
import KeychainAccess
import Combine

enum SearchType {
    case newArrival // 新着
    case textSearch // 検索
    
    init() {
        self = SearchType.newArrival
    }
}

protocol UTubeUsecase {
    func getSearchParam(param: String)
    
    func textSearchedPublisher() -> AnyPublisher<TextSearchedEntity, Error>
    func soaringPublisher() -> AnyPublisher<SoaringEntity, Error>
}

class UTubeInteractor {
    
    var textSearchedItems: TextSearchedEntity
    var soaringItems: SoaringEntity
    var textSearchedListPublisher: AnyPublisher<TextSearchedEntity, Error> { textSearchedSubject.eraseToAnyPublisher() }
    var soaringListPublisher: AnyPublisher<SoaringEntity, Error> { soaringSubject.eraseToAnyPublisher() }

    private var searchParam: String?
    private var nextPageToken: String?
    private var searchType = SearchType()
    private var previousParam: String?
    private let textSearchedSubject = PassthroughSubject<TextSearchedEntity, Error>()
    private let soaringSubject = PassthroughSubject<SoaringEntity, Error>()
    
    init() {
        self.textSearchedItems = TextSearchedEntity() // テキスト検索結果
        self.soaringItems = SoaringEntity() // 急上昇
        self.searchParam = nil // 検索ワード
        self.nextPageToken = nil // 検索結果件数が多い場合GCPから返却される 続きをリクエストするtoken
        self.previousParam = nil
    }
}

extension UTubeInteractor: UTubeUsecase, UTubePresentation {
    
    func textSearchedPublisher() -> AnyPublisher<TextSearchedEntity, Error> {
        return self.textSearchedListPublisher
    }
    
    func soaringPublisher() -> AnyPublisher<SoaringEntity, Error> {
        return self.soaringListPublisher
    }
    
    func textFieldDidChanged(searchWord: String) {}
    
    func getSearchParam(param: String) {
        if !param.isEmpty {
            self.searchType = .textSearch
        }
        self.makeSearchURL(param: param)
    }
    
    private func makeSearchURL(param: String) {
        guard let apiKey = self.getApiKey() else { return }
        let youTubeListURL = APIConstants().youTubeListURL
        let searchChannelURL = APIConstants().searchChannelURL
        var searchURL = String()
        
        switch self.searchType {
            
        case .newArrival:
            searchURL = (String(format: youTubeListURL, apiKey))
        case .textSearch:
            searchURL = (String(format: searchChannelURL, param, apiKey))
        }
        if self.nextPageToken != nil, self.nextPageToken != "" {
            searchURL += "&pageToken=" + self.nextPageToken!
        }
        self.fetchSearchResult(urlString: searchURL, param: param)
    }
    
    private func fetchSearchResult(urlString: String, param: String) {
        
        guard let url = URL(string: urlString) else { fatalError() }
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { response in
                
                guard let data = response.data else { return }
                
                do {
                    
                    switch self.searchType {
                        
                    case .textSearch:
                        let result: TextSearchedEntity = try JSONDecoder().decode(TextSearchedEntity.self, from: data)
                        
                        if self.previousParam == param, self.nextPageToken != nil, self.nextPageToken != "" {
                            self.textSearchedItems.addNewItems(newItems: result.items ?? [])
                            
                        } else {
                            self.textSearchedItems = TextSearchedEntity()
                            self.textSearchedItems = result
                        }
                        
                        self.nextPageToken = result.nextPageToken
                        self.textSearchedSubject.send(self.textSearchedItems)
                        
                    case .newArrival:
                        let result: SoaringEntity = try JSONDecoder().decode(SoaringEntity.self, from: data)
                        self.soaringItems = result
                        self.soaringSubject.send(self.soaringItems)
                    }
                } catch {
                    print("")
                }
                self.previousParam = param
            }
    }
    
    private func getApiKey() -> String? {
        let keychain = Keychain(service: "mmsc.am32-gmail.com.UTube")
        struct KeyChainAccessError: Error {}
        
        do {
            let key = try keychain.getString("api_key")
            return key
        } catch {
            print("Failure: \(KeyChainAccessError())")
            return nil
        }
    }
}
