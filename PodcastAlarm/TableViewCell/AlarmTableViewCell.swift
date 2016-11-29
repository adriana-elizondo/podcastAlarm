//
//  AlarmTableViewCell.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 26/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit

class AlarmTableViewCell : UITableViewCell{
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var alarmTitle: UILabel!
    
    @IBOutlet weak var alarmStatus: UISwitch!
    
    func setupCellWithAlarm(alarm : Alarm){
        alarmTime.text = formattedTime(time: alarm.time)
        alarmTitle.text = alarm.name
        alarmStatus.isOn = alarm.status
    }
    
    private func formattedTime(time: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: time)
    }
}
