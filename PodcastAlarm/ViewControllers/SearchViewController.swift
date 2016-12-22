//
//  SearchViewController.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 21/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController : UIViewController{
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    var alarm : Alarm?
    fileprivate var searchResults = [Podcast]()
    fileprivate var selectedIndex = 0
    
    fileprivate lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.hidesNavigationBarDuringPresentation = false
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.sizeToFit()
        controller.searchBar.placeholder = "Search for podcasts"
        controller.searchBar.delegate = self
        
        return controller
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = searchController.searchBar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let podcastDetailController = segue.destination as? PodcastViewController{
            podcastDetailController.podcast = searchResults[selectedIndex]
            podcastDetailController.alarm = alarm
        }
    }
}

extension SearchViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NetworkHelper.getDataWithUrl(stringUrl: PodcastHelper.urlForItunesAPIithParameters(parameters: searchBar.text ?? ""), encoding: .JSON) { (success, response, error) in
            
            if success, let results = (response as? [String: Any?])?["results"]{
                self.searchResults = PodcastHelper.podcastArrayFromJSON(jsonArray: results as? [Any])
            }else{
                print("Error \(error)")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.searchController.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as? SearchTableViewCell
        cell?.setUpCellWithEntity(entity: searchResults[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "podcastDetails", sender: self)
    }
    
}
