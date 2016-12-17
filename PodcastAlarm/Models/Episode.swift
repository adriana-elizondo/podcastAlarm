//
//  PodcastItem.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 22/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import SWXMLHash

struct Episode : XMLIndexerDeserializable{
    var title : String
    var description : String
    var publicationDate :String
    var duration : String?
    var contentUrl : String
    var localPath : String
    
    static func deserialize(_ node: XMLIndexer) throws -> Episode {
        return try Episode(
            title: node["title"].value() ?? "",
            description: node["description"].value() ?? "No more data available for this episode at this time",
            publicationDate: node["pubDate"].value() ?? "",
            duration: node["itunes:duration"].value() ?? "",
            contentUrl: node["enclosure"].element?.attribute(by: "url")?.text ?? "",
            localPath : ""
        )
    }
}
