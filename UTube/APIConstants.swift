//
//  APIConstants.swift
//  UTube
//
//  Created by 百瀬篤志 on 2022/03/15.
//

import Foundation

class APIConstants: NSObject {
    
    // youtube一覧 (日本)
    let youTubeListURL = "https://www.googleapis.com/youtube/v3/videos?part=snippet&chart=mostPopular&regionCode=jp&key=%@"

    // channel検索 (世界)
    let searchChannelURL = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=40&order=date&regionCode=jp&q=%@&type=video&key=%@"
        
    // 新着一覧のセル押下検索
    let searchChannelIDURL = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=%@&maxResults=5&order=date&type=video&key=%@"
}
