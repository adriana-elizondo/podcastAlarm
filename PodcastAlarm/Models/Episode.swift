//
//  PodcastItem.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 22/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import SWXMLHash
import RealmSwift

internal struct Episode : XMLIndexerDeserializable{
    var title : String
    var episodeDescription : String
    var publicationDate :String
    var duration : String?
    var contentUrl : String
    var localPath : String
    
    static func deserialize(_ node: XMLIndexer) throws -> Episode {
        return try Episode(
            title: node["title"].value() ?? "",
            episodeDescription: node["description"].value() ?? "No more data available for this episode at this time",
            publicationDate: node["pubDate"].value() ?? "",
            duration: node["itunes:duration"].value() ?? "",
            contentUrl: node["enclosure"].element?.attribute(by: "url")?.text ?? "",
            localPath : ""
        )
    }
}

extension Episode : Persistable {
    init(managedObject: EpisodeObject) {
        title = managedObject.title
        episodeDescription = managedObject.episodeDescription
        publicationDate = managedObject.publicationDate
        duration = managedObject.duration
        contentUrl = managedObject.contentUrl
        localPath = managedObject.localPath
    }
    
    func managedObject() -> EpisodeObject {
        let episodeObject = EpisodeObject()
        episodeObject.title = self.title
        episodeObject.episodeDescription = self.episodeDescription
        episodeObject.publicationDate = self.publicationDate
        episodeObject.duration = self.duration ?? ""
        episodeObject.contentUrl = self.contentUrl
        episodeObject.localPath = self.localPath
        
        return episodeObject
    }
}

final class EpisodeObject : Object {
    dynamic var title : String = "None"
    dynamic var episodeDescription : String = ""
    dynamic var publicationDate :String = ""
    dynamic var duration : String = ""
    dynamic var contentUrl : String = ""
    dynamic var localPath : String = ""
    
}
