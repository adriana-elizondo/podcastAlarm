//
//  Alarm.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 24/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import RealmSwift

class Alarm : Object{
    dynamic var id = ""
    dynamic var time = Date()
    dynamic var name = "Alarm"
    dynamic var soundName = "Default"
    dynamic var soundPath = ""
    dynamic var episode : Episode?
    dynamic var frequency = 0
    dynamic var status = false
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

enum Frequency : String{
    case Never = "Never",
    Sunday = "Every Sunday",
    Monday = "Every Monday",
    Tuesday = "Every Tuesday",
    Wednesday = "Every Wednesday",
    Thursday = "Every Thursday",
    Friday = "Every Friday",
    Saturday = "Every Saturday"
    
    static func fromIndex(index: Int) -> Frequency{
        switch index {
        case 0:
            return Never
        case 1:
            return Sunday
        case 2:
            return Monday
        case 3:
            return Tuesday
        case 4:
            return Wednesday
        case 5:
            return Thursday
        case 6:
            return Friday
        case 7:
            return Saturday
        default:
            return Never
        }
    }
    
    static let allValues = [Never.rawValue, Sunday.rawValue, Monday.rawValue, Tuesday.rawValue, Wednesday.rawValue, Thursday.rawValue, Friday.rawValue, Saturday.rawValue]
}
