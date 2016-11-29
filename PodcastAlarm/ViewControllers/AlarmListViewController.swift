//
//  AlarmListViewController.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 26/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit

class AlarmListViewController : UIViewController{
    fileprivate var alarmList = [Alarm](){
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fecthAlarmList()
    }
    
    private func fecthAlarmList(){
        alarmList = RealmHelper.fetchAlarms()
    }
}

extension AlarmListViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell") as? AlarmTableViewCell
        cell?.setupCellWithAlarm(alarm: alarmList[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
