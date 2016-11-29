//
//  PodcastDetail.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 21/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import SWXMLHash

struct PodcastDetail{
    var title = ""
    var description = ""
    var author = ""
    var category = ""
    var imageUrl = ""
    var copyRight = ""
    var episodes = [Episode]()
    
    init() {
        
    }
    
    init(xmlData : Data) {
        let xml = SWXMLHash.lazy(xmlData)
        title = xml["rss"]["channel"]["title"].element?.text?.removingPercentEncoding ?? ""
        description = xml["rss"]["channel"]["description"].element?.text?.removingPercentEncoding ?? ""
        author = xml["rss"]["channel"]["itunes:author"].element?.text?.removingPercentEncoding ?? ""
        category = xml["rss"]["channel"]["itunes:category"].element?.text?.removingPercentEncoding ?? ""
        imageUrl = xml["rss"]["channel"]["image"]["url"].element?.text?.removingPercentEncoding ?? ""
        copyRight = xml["rss"]["channel"]["copyright"].element?.text?.removingPercentEncoding ?? ""
        
        do{
            if let episodeList : [Episode] = try xml["rss"]["channel"]["item"].value(){
                episodes = episodeList
            }
        }catch{
            print("Couldnt parse episodes \(error)")
        }
    }
}
