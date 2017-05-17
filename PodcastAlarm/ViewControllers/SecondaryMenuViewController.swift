//
//  SecondaryMenuViewController.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 25/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit

class SecondaryMenuViewController : UIViewController{
    fileprivate var elements = [String]()
    var type : DataType?{
        didSet{
            if let setType = type as DataType?{
                elements = DataHelper.itemsForType(type: setType)
            }
        }
    }
    
    var alarm : Alarm?
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
    }
    
}

extension SecondaryMenuViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")
        
        if type == DataType.podcast{
            let downloadCell = tableView.dequeueReusableCell(withIdentifier: "downloadCell") as? DownloadEpisodeTableViewCell
            
            if let episode = alarm?.episode{
                downloadCell?.setUpWithEpisode(episode: episode)
            }
            
            return downloadCell ?? UITableViewCell()
        }
        
        cell?.textLabel?.text = DataHelper.valuesForType(type: type ?? DataType.frequency, index: indexPath.row, alarm: alarm)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard alarm != nil, type != nil else {return}
        switch type!{
        case .frequency:
            alarm?.frequency = Frequency.fromIndex(index: indexPath.row).hashValue
        default:
            break
        }
        
        RealmHelper.persistObject(object: alarm!){(success, error) in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
