//
//  EpisodeTableViewCell.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 22/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit

class EpisodeTableViewCell : UITableViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var episodeDescription: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var publicationDate: UILabel!
    @IBOutlet weak var isDownloadedLabel: UILabel!
    
    func setupCellWithEpisode(episode : Episode){
        title.text = episode.title.stringWithoutHtmlTags()
        episodeDescription.text = episode.description.stringWithoutHtmlTags()
        duration.text = episode.durationInMinutes()
        publicationDate.text = episode.formattedDate()
        isDownloadedLabel.isHidden = !episode.isEpisodeAvailableLocally()
    }
}
