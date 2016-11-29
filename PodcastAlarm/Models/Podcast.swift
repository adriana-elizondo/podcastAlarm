//
//  Podcast.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 21/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import ObjectMapper

class Podcast : Mappable{
    dynamic var title = ""
    dynamic var author = ""
    dynamic var imageUrl = ""
    dynamic var feedUrl = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        title <- map["collectionName"]
        author <- map["artistName"]
        imageUrl <- map["artworkUrl100"]
        feedUrl <- map["feedUrl"]
    }
    
}
