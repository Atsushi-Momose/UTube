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

enum searchType: Int {
    case newArrival = 1// 新着
    case textSearch // 検索
    case channelSearch // 特定のチャンネル検索
}

protocol UTubeUsecase {
    func getSearchParam(param: String)
    func listPublisher() -> AnyPublisher<[UTubeEntity], Error>
}

class UTubeInteractor {
    
    var searchedItems: [UTubeEntity]
    private var searchParam: String?
    private var nextPageToken: String?
    
    var utubeListPublisher: AnyPublisher<[UTubeEntity], Error> { subject.eraseToAnyPublisher() }
    private let subject = PassthroughSubject<[UTubeEntity], Error>()
    
    init() {
        self.searchedItems = [] // 検索結果
        self.searchParam = nil // 検索ワード
        self.nextPageToken = nil // 検索結果件数が多い場合GCPから返却される 続きをリクエストするtoken
    }
}

extension UTubeInteractor: UTubeUsecase, UTubePresentation {
   
    // protocol
    func listPublisher() -> AnyPublisher<[UTubeEntity], Error> {
        return self.utubeListPublisher
    }
    
    func textFieldDidChanged(searchWord: String) {}
    
    func getSearchParam(param: String) {
        self.makeSearchURL(searchType: .textSearch, param: param, channelID: nil)
    }
    
    private func fetchSearchResult(param urlString: String) {
        
        guard let url = URL(string: urlString) else { fatalError() }
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { response in
                
                guard let data = response.data else { return }
                
                do {
                    let utubeEntity = try JSONDecoder().decode(UTubeEntity.self, from: data)
                    self.searchedItems.append(utubeEntity)
                
                    // presenterに通知
                    //  NotificationCenter.default.post(name: .textSearchDidEnd, object: nil, userInfo: ["items": self.searchedItems])
                    
                    
                } catch {
                    print("")
                }
                self.subject.send(self.searchedItems)
            }
    }
    
    private func makeSearchURL(searchType: searchType, param: String, channelID: String?) {
        guard let apiKey = self.getApiKey() else { return }
        let youTubeListURL = APIConstants().youTubeListURL
        let searchChannelURL = APIConstants().searchChannelURL
        
        var searchURL = String()
        
        switch searchType {
        case .newArrival:
            searchURL = (String(format: youTubeListURL, apiKey))
            if self.nextPageToken != nil, self.nextPageToken != "" {
                searchURL += "&pageToken=" + self.nextPageToken!
            }
        case .textSearch:
            searchURL = (String(format: searchChannelURL, param, apiKey))
            if self.nextPageToken != nil , self.nextPageToken != "" {
                searchURL += "&pageToken=" + self.nextPageToken!
            }
        case .channelSearch:
            guard let channelId = channelID else { return }
            searchURL = (String(format: APIConstants().searchChannelIDURL, channelId, apiKey))
        }
        self.fetchSearchResult(param: searchURL)
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
    
    //        // 新着一覧
    //        private func loadYouTubeList(url: String, searchType: searchType) {
    //
    //            let apiManager = APIManager()
    //
    //            apiManager.ConnectionAPI(url: url, success: {(result: Data) -> Void in
    //
    //                let decoder: JSONDecoder = JSONDecoder()
    //                do {
    //                    // 初回取得の場合
    //                    if self.isFirst {
    //                        self.youtubeList = try decoder.decode(YouTubeList.self, from: result)
    //                        self.isFirst = false
    //                    } else {
    //
    //                        switch searchType {
    //                        case .channelSearch:
    //                            self.channelIDSearchResult = try decoder.decode(YouTubeList.self, from: result)
    //    //                        let list: YouTubeList = try decoder.decode(YouTubeList.self, from: result)
    //    //
    //    //                        guard let appendItem = list.items, appendItem.count != 0 else {
    //    //                            self.eventSubject.onCompleted()
    //    //                            return
    //    //                        }
    //    //
    //    //                        // 続きを取得するためのトークンを設定
    //    //                        self.youtubeList.nextPageToken = list.nextPageToken
    //    //                        // youtubeListに追加
    //    //                        let _ = appendItem.map({ self.youtubeList.items?.append($0) })
    //                        case .newArrival, .textSearch:
    //                            // 2回目以降
    //                            let list: YouTubeList = try decoder.decode(YouTubeList.self, from: result)
    //
    //                            guard let appendItem = list.items, appendItem.count != 0 else {
    //                                self.eventSubject.onCompleted()
    //                                return
    //                            }
    //
    //                            // 続きを取得するためのトークンを設定
    //                            self.youtubeList.nextPageToken = list.nextPageToken
    //
    //                            // youtubeListに追加
    //                            let _ = appendItem.map({ self.youtubeList.items?.append($0) })
    //                        }
    //                    }
    //                    self.eventSubject.onNext(1)
    //                } catch {
    //                    print("json convert failed in JSONDecoder", error.localizedDescription)
    //                }
    //            }, failure: {(result: Error?) -> Void in
    //
    //            })
    //        }
    //    }
    
    
    //        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: [:])
    //
    //            .validate(statusCode: 200..<300)
    //            .responseJSON { response in
    //                switch response.result {
    //                case .success(_):
    //                    do {
    //                        guard let data = response.data else { return }
    //
    //                        let jsonResult = try JSONSerialization.jsonObject(with: data) as! NSMutableDictionary
    //
    //                        self.youtubeNextPageToken = jsonResult["nextPageToken"] as! String?
    //                        let ary = jsonResult["items"] as! NSArray
    //                        //let youtubeList = YouTubeList(ary: ary)
    //                        success(ary)
    //                    }
    //                    catch {
    //                        failure(response.error)
    //                    }
    //                case .failure(_):
    //                    failure(response.error!)
    //                }
    //        }

}

extension Notification.Name {
    static let textSearchDidEnd = Notification.Name("textSearchDidEnd")
}

