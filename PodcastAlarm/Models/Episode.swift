//
//  PodcastItem.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 22/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import SWXMLHash

class Episode{
    var title = ""
    var description = ""
    var publicationDate = ""
    var duration = 0
    var contentUrl = ""
    
    var xml : SWXMLHash = {
        return SWXMLHash.config {
            config in
            config.shouldProcessLazily = true
        }
    }()
    
    init(xmlString : String) {
        let indexer = xml.parse(xmlString)
        title = indexer["chanel"]["item"]["title"].element?.text ?? ""
        description = indexer["chanel"]["item"]["description"].element?.text ?? ""
        publicationDate = indexer["chanel"]["item"]["pubDate"].element?.text ?? ""
        contentUrl = indexer["chanel"]["item"]["media:content"].element?.text ?? ""
    }
}
