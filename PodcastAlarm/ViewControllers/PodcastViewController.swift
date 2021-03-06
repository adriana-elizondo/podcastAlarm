//
//  PodcastViewController.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 22/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit

class PodcastViewController : UIViewController{
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var podcastTitle: UILabel!
    @IBOutlet weak var podcastDescription: UILabel!
    @IBOutlet weak var copyright: UILabel!
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView()
        }
    }
    
    //Variables
    var podcast = Podcast()
    var alarm : Alarm?
    
    fileprivate var podcastDetail : PodcastDetail?{
        didSet{
            guard podcastDetail != nil else {return}
            
            setupViewWithDetail(podcastDetail: podcastDetail!)
            if let episodes = podcastDetail?.episodes as [Episode]?{
                self.episodes = episodes
            }
        }
    }
    
    fileprivate var episodes = [Episode](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromServer()
    }
    
    fileprivate func createAlarmFromPodcast(episode: Episode){
        var newAlarm = Alarm()
        
        if let currentAlarm = self.alarm as Alarm?{
            newAlarm = currentAlarm
        }else{
            newAlarm.id = UUID().uuidString
            newAlarm.name = self.podcastDetail?.title ?? ""
            newAlarm.episode = episode.managedObject()
        }
        
        if let alarmController = self.storyboard?.instantiateViewController(withIdentifier: "AlarmViewController") as? AlarmViewController{
            alarmController.alarm = newAlarm
            
            let navigationController = UINavigationController.init(rootViewController: alarmController)
            self.present(navigationController, animated: true){ _ in
                self.tableView.setEditing(false, animated: true)
            }
        }
        
    }
}

extension PodcastViewController{
    fileprivate func setupViewWithDetail(podcastDetail: PodcastDetail){
        if let url = URL.init(string: podcastDetail.imageUrl){
            self.podcastImage.hnk_setImageFromURL(url)
        }
        self.podcastTitle.text = podcastDetail.title
        self.podcastDescription.text = podcastDetail.description
        self.copyright.text = podcastDetail.copyRight
        self.category.text = podcastDetail.category
    }
    
    fileprivate func getDataFromServer(){
        NetworkHelper.getDataWithUrl(stringUrl: podcast.feedUrl, encoding: .XML){ (success, response, error) in
            if success, let responseData = response as? Data{
                DispatchQueue.main.async {
                    self.podcastDetail = PodcastDetail.init(xmlData: responseData)
                }
            }else{
                print("Error \(String(describing: error))")
            }
        }
    }
}

extension PodcastViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as? EpisodeTableViewCell
        cell?.setupCellWithEpisode(episode: episodes[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let episode = episodes[indexPath.row]
        let playAction = UITableViewRowAction.init(style: .destructive, title: "Play") { (action, indexpath) in
            if let url = URL.init(string: episode.contentUrl){
                PlayerHelper.sharedHelper.streamFromUrl(url: url)
            }
            tableView.endEditing(true)
        }
        
        let createAlarmAction = UITableViewRowAction.init(style: .normal, title: "Select"){ (action, indexpath) in
            self.createAlarmFromPodcast(episode: episode)
        }
        
        return [playAction, createAlarmAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        createAlarmFromPodcast(episode: episode)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
    }
    
}
