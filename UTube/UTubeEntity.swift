//
//  UTubeEntity.swift
//  UTube
//
//  Created by 百瀬篤志 on 2022/03/15.
//

import Foundation

// 文字検索
struct TextSearchedEntity: Codable, Hashable {
    private var pageInfo: pInfo?
    private var etag: String?
    private var kind: String?
    private var regionCode: String?
    var items: [itemInfoList]?
    var nextPageToken: String?
    
    mutating func addNewItems(newItems: [itemInfoList]) {
        newItems.forEach { items?.append($0) }
    }
    
    struct pInfo: Codable, Hashable {
        private var resultsPerPage: NSInteger?
        private var totalResults: NSInteger?
    }
    
    struct itemInfoList: Codable, Hashable {
        var etag: String?
        var kind: String?
        var id: idItems?
        var snippet: snipetItem?
    }
    
    struct idItems: Codable, Hashable {
        private var kind: String?
        private var videoId: String?
    }
    
    struct snipetItem: Codable, Hashable {
        var thumbnails: thumbnailList?
        var channelId: String?
        var title: String?
        var publishedAt: String?
        var description: String?
        var liveBroadcastContent: String?
        var channelTitle: String?
    }
    
    struct thumbnailList: Codable, Hashable {
        private var high: defaultItems?
        private var medium: defaultItems?
        var `default`: defaultItems?
    }
    
    struct defaultItems: Codable, Hashable {
        var url: String?
        var width: NSInteger?
        var height: NSInteger?
    }
}

struct SoaringEntity: Codable, Hashable {
    
    private var etag: String?
    private var kind: String?
    var items: [itemInfoList]?
    
    struct itemInfoList: Codable, Hashable {
        var etag: String?
        var kind: String?
        var id: String?
        var snippet: snipetItem?
    }
    
    struct snipetItem: Codable, Hashable {
        var thumbnails: thumbnailList?
        var channelId: String?
        var title: String?
        var publishedAt: String?
        var description: String?
        var liveBroadcastContent: String?
        var channelTitle: String?
        var categoryId: String?
        var tags: [String]?
        var defaultAudioLanguage: String?
        var localized: localizedList?
    }
    
    struct localizedList: Codable, Hashable {
        var title: String?
        var description: String?
    }
    
    struct thumbnailList: Codable, Hashable {
        var `default`: defaultItems?
        var high: defaultItems?
        var medium: defaultItems?
    }
    
    struct defaultItems: Codable, Hashable {
        var url: String?
        var width: NSInteger?
        var height: NSInteger?
    }
}
