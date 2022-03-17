//
//  ContentView.swift
//  UTube
//
//  Created by 百瀬篤志 on 2022/03/15.
//

import SwiftUI
import ASCollectionView

struct ContentView: View {
    
    @State private var searchWord = ""
    @State var dataExample = (0 ..< 30).map { $0 }
    @State var searchedItems = UTubeEntity()
    
//    @State var title = interactor?.searchedItems.itemInfoList.snipetItem.title ?? ""
    
    @ObservedObject var interactor = UTubeInteractor()
    
    var router = UTubeRouter()
    var presenter = UtubePresenter(interactor: UTubeInteractor())
    
    var body: some View {
        
        VStack {
            TextField("検索ワードを入力", text: $searchWord)
                .onChange(of: self.searchWord) { newValue in
                    self.presenter.textFieldDidChanged(searchWord: newValue)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            
            ASCollectionView(data: dataExample, dataID: \.self) { item, _ in
                Color.blue
                    .overlay(Text("\(item)"))
            }
            .layout {
                .grid(
                    layoutMode: .fixedNumberOfColumns(3),
                    itemSpacing: 5,
                    lineSpacing: 5,
                    itemSize: .absolute(100))
            }
            
            Spacer()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
