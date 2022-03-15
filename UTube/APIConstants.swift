//
//  APIConstants.swift
//  UTube
//
//  Created by 百瀬篤志 on 2022/03/15.
//

import Foundation

class APIConstants: NSObject {
    
    //R.swiftを使用予定
    
    // youtube一覧
    let youTubeListURL = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=40&order=date&type=video&key=%@"
    
    // channel検索
    let searchChannelURL = "https://www.googleapis.com/youtube/v3/search?type=video&part=snippet&maxResults=40&order=date&q=%@&key=%@"
    
    // 新着一覧のセル押下検索
    let searchChannelIDURL = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=%@&maxResults=5&order=date&type=video&key=%@"
}
