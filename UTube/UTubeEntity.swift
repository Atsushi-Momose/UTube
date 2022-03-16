//
//  UTubeEntity.swift
//  UTube
//
//  Created by 百瀬篤志 on 2022/03/15.
//

import Foundation

struct UTubeEntity: Codable {
    
    var pageInfo: pInfo?
    var etag: String?
    var kind: String?
    var items: [itemInfoList]?
    var nextPageToken: String?
    var regionCode: String?
    
    struct pInfo: Codable {
        var resultsPerPage: NSInteger?
        var totalResults: NSInteger?
    }
    
    struct itemInfoList: Codable {
        var etag: String?
        var kind: String?
        var id: idItems?
        var snippet: snipetItem?
    }
    
    struct idItems: Codable {
        var kind: String?
        var videoId: String?
    }
    
    struct snipetItem: Codable {
        var thumbnails: thumbnailList?
        var channelId: String?
        var title: String?
        var publishedAt: String?
        var description: String?
        var liveBroadcastContent: String?
        var channelTitle: String?
    }
    
    struct thumbnailList: Codable {
        var `default`: defaultItems?
        var high: defaultItems?
        var medium: defaultItems?
    }
    
    struct defaultItems: Codable {
        var url: String?
        var width: NSInteger?
        var height: NSInteger?
    }
}


