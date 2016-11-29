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
