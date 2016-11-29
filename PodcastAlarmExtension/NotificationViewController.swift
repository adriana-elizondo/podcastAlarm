//
//  NotificationViewController.swift
//  PodcastAlarmExtension
//
//  Created by Adriana Elizondo on 29/11/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        print("notification!!! \(notification)")
    }

}
