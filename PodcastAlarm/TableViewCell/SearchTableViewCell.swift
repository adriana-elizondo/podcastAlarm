//
//  SearchTableViewCell.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 21/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit
import Haneke

class SearchTableViewCell : UITableViewCell {
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var podcastTitle: UILabel!
    @IBOutlet weak var podcastAuthor: UILabel!
    
    func setUpCellWithEntity(entity : Podcast){
        podcastTitle.text = entity.title
        podcastAuthor.text = entity.author
        
        if let url = URL.init(string: entity.imageUrl){
          podcastImage.hnk_setImageFromURL(url)
        }
    }
}
