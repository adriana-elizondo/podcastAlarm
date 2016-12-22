//
//  Extensions.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 26/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit

extension String{
    func stringWithoutHtmlTags() -> String{
        do {
            let regex =  "<[^>]+>"
            let expr = try NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
            
            return expr.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.characters.count), withTemplate: "")
            
        } catch {
            print("There was an error \(error)")
        }
        
        return self
    }
}

extension Episode{
    func isEpisodeAvailableLocally() -> Bool{
        if let url = URL.init(string: self.contentUrl){
            return FileManager.default.fileExists(atPath: DownloadHelper.sharedInstance.pathToDirectory.appendingPathComponent(url.lastPathComponent).path)
        }
        
        return false
    }
    
    func durationInMinutes() -> String{
        if let duration = self.duration as String?{
            if let intDuration = Int(duration){
                let result = intDuration > 60 ? intDuration / 60 : intDuration
                return String(result) + " minutes"
            }
            return String(duration)
        }
        
        return "Not available"
    }

    func formattedDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        let date = dateFormatter.date(from: self.publicationDate)
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date ?? Date())
    }

}
