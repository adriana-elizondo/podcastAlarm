//
//  PodcastHelper.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 21/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import ObjectMapper

class PodcastHelper{
    
    static func podcastArrayFromJSON(jsonArray: [Any]?) -> [Podcast]{
        var podcastArray = [Podcast]()
        guard jsonArray != nil else {return podcastArray}
        
        for json in jsonArray!{
            if let currentPodcast = json as? [String : Any],
               let podcast = Podcast(JSON: currentPodcast){
                podcastArray.append(podcast)
            }
        }
        
        return podcastArray
    }
    
    static func urlForItunesAPIithParameters(parameters: String) -> String{
         return baseUrl+parameters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!+defaultParameters
    }
}
