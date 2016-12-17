//
//  DownloadEpisodeTableViewCell.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 07/12/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit

class DownloadEpisodeTableViewCell : UITableViewCell{
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    var url = ""
    
    func setUpWithEpisode(episodeName: String, url: String){
        self.episodeName.text = episodeName
        self.url = url
    }
    
    @IBAction func downloadEpisode(_ sender: Any) {
        DownloadHelper.sharedInstance.downloadPodcastFromUrl(stringUrl: self.url)
    }
    
}
