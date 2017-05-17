//
//  PlayerHelper.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 11/19/16.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class PlayerHelper : NSObject{
    static let sharedInstance = PlayerHelper()
    
    static var sharedHelper: PlayerHelper {
        get { return sharedInstance }
    }
    
    private var player = AVPlayer()
    
    func streamFromUrl(url: URL){
            player = AVPlayer.init(url: url)
        
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            UIApplication.shared.keyWindow?.rootViewController?.present(playerViewController, animated: true) {
                playerViewController.player!.play()
        }
    }
    
    func stopAudio(){
        player.pause()
    }
}
