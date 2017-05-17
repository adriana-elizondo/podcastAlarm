//
//  AlarmViewController.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 24/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit

class AlarmViewController : UIViewController{
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView()
        }
    }
    
    var alarm : Alarm?
    
    private var selectedTime = Date()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeDefault()
    }
    
    private func initializeDefault(){
        guard alarm == nil else {return}
        alarm = Alarm()
    }
    
    //ACTIONS
    @IBAction func saveAlarm(_ sender: Any) {
        if let alarm = self.alarm as Alarm?{
            alarm.status = true
            alarm.time = selectedTime
            RealmHelper.persistObject(object: alarm){ (success, error) in
                if success{
                    NotificationHelper.sharedHelper.addNotificationForAlarm(alarm: alarm)
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didChangeValue(_ sender: Any) {
        if let timePicker = sender as? UIDatePicker{
            selectedTime = timePicker.date
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SecondaryMenuViewController,
            let tableview = sender as? UITableView{
            controller.type = DataType(rawValue: tableview.tag)
            controller.alarm = alarm
        }
    }
}

extension AlarmViewController{
    fileprivate typealias AlarmCell = (title: String, detail: String)?
    
    //LOGIC
    fileprivate func setupViews(){
        tableView.reloadData()
        if let alarm = self.alarm as Alarm?{
            datePicker.date = alarm.time
        }
    }
    
    fileprivate func cellConfigForRow(rowNumber: Int) -> AlarmCell{
        switch rowNumber {
        case 0:
            return("Repeat", Frequency.fromIndex(index: alarm?.frequency ?? 0).rawValue)
        case 1:
            return("Name", alarm?.name ?? "Name")
        case 2:
            return("Sound", alarm?.soundName ?? "Default")
        case 3:
            return("Snooze Podcast", alarm?.episode?.title ?? "None")
            
        default:
            return nil
        }
    }
}

extension AlarmViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell")
        let configTuple = cellConfigForRow(rowNumber: indexPath.row)
        
        cell?.textLabel?.text = configTuple?.title
        cell?.detailTextLabel?.text = configTuple?.detail
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.tag = indexPath.row
        self.performSegue(withIdentifier: "secondaryMenu", sender: tableView)
    }
}

