//
//  DataHelper.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 25/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation

enum DataType : Int{
   case frequency, label, sound, podcast
}

struct DataHelper{
    static func itemsForType(type: DataType) -> [String]{
        switch type {
        case .frequency:
            return Frequency.allValues
        case .label:
            return ["Name"]
        case .sound:
            return ["Default"]
        case .podcast:
            return ["Episode name"]
        }
    }
    
    static func valuesForType(type: DataType, index: Int, alarm: Alarm?) -> String{
        switch type {
        case .frequency:
            return Frequency.fromIndex(index: index).rawValue
        case .label:
            return alarm?.name ?? "Alarm"
        case .sound:
            return "Default"
        case .podcast:
            return alarm?.episodeName ?? "None"
        }
    }
}
