//
//  ContentView.swift
//  UTube
//
//  Created by 百瀬篤志 on 2022/03/15.
//

import SwiftUI

struct ContentView: View {
    @State private var searchWord = ""
    
    var body: some View {
        
        VStack {
            
            TextField("検索ワードを入力", text: $searchWord)
            
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Spacer()
            
            LinearGradient(gradient: Gradient(colors: [.black, .red]), startPoint: .top, endPoint: .bottom)                .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
