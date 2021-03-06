//
//  ContentView.swift
//  UTube
//
//  Created by 百瀬篤志 on 2022/03/15.
//

import SwiftUI
import SDWebImageSwiftUI
import SVProgressHUD

struct ContentView: View {
    
    @State private var searchWord = ""
    @ObservedObject var presenter = UtubePresenter(interactor: UTubeInteractor())
    @State var searchedItems = TextSearchedEntity()
    @State var soaringItems = SoaringEntity()
    var router = UTubeRouter()
    var body: some View {
        
        VStack {
            TextField("検索ワードを入力", text: $searchWord)
                .onChange(of: self.searchWord) { newValue in
                    SVProgressHUD.show()
                    self.presenter.textFieldDidChanged(searchWord: newValue)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List {
                let items = self.searchedItems.items
                
                ForEach(items ?? [], id: \.self) { item in
                    VStack {
                        WebImage(url: URL(string: item.snippet?.thumbnails?.default?.url ?? ""))
                            .resizable()
                            .frame(width: 240, height: 160, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                        
                        VStack(spacing: 5) {
                            Text (item.snippet?.title ?? "") //タイトル
                                .font(.headline)
                            
                            Text (item.snippet?.channelTitle ?? "") // ちゃんねる名
                                .font(.footnote)
                        }
                    }
                    .onAppear() {
                        // 一番下までスクロールした時にnextPageTokenがあれば取得を行う
                        if self.searchedItems.items?.last == item, !self.searchedItems.nextPageToken.isEmpty  {
                            SVProgressHUD.show()
                            self.presenter.textFieldDidChanged(searchWord: self.searchWord)
                        }
                    }
                }
            }

//            List {
//                let items = self.soaringItems.items
//
//                ForEach(items ?? [], id: \.self) { item in
//                    VStack {
//                        WebImage(url: URL(string: item.snippet?.thumbnails?.default?.url ?? ""))
//                            .resizable()
//                            .frame(width: 240, height: 160, alignment: .center)
//                            .aspectRatio(contentMode: .fit)
//
//                        VStack(spacing: 5) {
//                            Text (item.snippet?.title ?? "") //タイトル
//                                .font(.headline)
//
//                            Text (item.snippet?.channelTitle ?? "") // ちゃんねる名
//                                .font(.footnote)
//                        }
//                    }
//                }
//            }

            .onChange(of: self.presenter.textSearchedItems) { items in
                self.searchedItems = items
                SVProgressHUD.dismiss()
                
            }
            
            .onChange(of: self.presenter.soaringItems) { items in
                self.soaringItems = items
                SVProgressHUD.dismiss()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
