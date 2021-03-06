//
//  NotificationHelper.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 11/19/16.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Haneke

enum ActionType: String {
    case play = "Play"
    case snooze = "Snooze"
    case stop = "Stop"
}

internal class NotificationHelper : NSObject{
    static let sharedInstance = NotificationHelper()
    
    public static var sharedHelper : NotificationHelper {
        get { return sharedInstance }
    }
    
    func setNotificationsCategory(){
        let playPodcastAction = UNNotificationAction(identifier: "Play",
                                                     title: "Play Podcast", options: [.foreground])
        let snoozeAction = UNNotificationAction(identifier: "Snooze",
                                                title: "Snooze", options: [.foreground])
        let deleteAction = UNNotificationAction(identifier: "Stop",
                                                title: "Stop", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: "notificationExtensionId",
                                              actions: [playPodcastAction,snoozeAction,deleteAction],
                                              intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func addNotificationForAlarm(alarm: Alarm){
        checkForAuthorization { (isAuthorized) in
            if isAuthorized{
                DispatchQueue.main.async {
                    let content = UNMutableNotificationContent()
                    content.title = "Morning Sunshine!"
                    content.subtitle = alarm.name
                    content.body = alarm.episode?.title ?? ""
                    content.sound = UNNotificationSound.init(named: "sorry_alarm")
                    content.categoryIdentifier = "notificationExtensionId"
                    content.userInfo = ["podcastUrl" : alarm.episode?.contentUrl ?? ""]
                    
                    // Deliver the notification in the alarm time.
                    var dateComponents = DateComponents()
                    dateComponents.hour = Calendar.current.component(.hour, from: alarm.time)
                    dateComponents.minute = Calendar.current.component(.minute, from: alarm.time)
                    
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
                    let request = UNNotificationRequest(identifier:alarm.id, content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().delegate = self
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                        if error != nil{
                            print("Unable to add notification \(String(describing: error))")
                        }else{
                            print("Alarm was added")
                        }
                    })
                    
                }
            }
        }
    }
    
    static func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if !granted{
                let alert = UIAlertController.init(title: "Error", message: "You must allow notifications for the alarms to work! :)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Allow", style: UIAlertActionStyle.default, handler: { (action) in
                    NotificationHelper.requestAuthorization()
                })
                
                let cancel = UIAlertAction(title: "Don't Allow", style: UIAlertActionStyle.cancel, handler: { (action) in
                    
                })
                
                alert.addAction(action)
                alert.addAction(cancel)
                
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }else{
                NotificationHelper.sharedHelper.setNotificationsCategory()
            }
        }
    }
    
    private func checkForAuthorization(completion: @escaping (_ isAuthorized: Bool) -> Void){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            completion(settings.authorizationStatus == .authorized)
            if settings.authorizationStatus != .authorized {
                let alertController = UIAlertController.init(title: "Error", message: "You must allow notifications to be notified when your alarm goes off", preferredStyle: .alert)
                
                let alertAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: { (action) in
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                        if granted{
                            NotificationHelper.sharedHelper.setNotificationsCategory()
                        }
                    }
                })
                alertController.addAction(alertAction)
                
                if let viewController = UIApplication.shared.keyWindow?.rootViewController{
                    viewController.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension NotificationHelper : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("will present notification")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("did receive notification")
        
        if let stringUrl = response.notification.request.content.userInfo["podcastUrl"] as? String,
            let url = URL(string: stringUrl){
            PlayerHelper.sharedHelper.streamFromUrl(url: url)
        }
        
        guard let action = ActionType(rawValue: response.actionIdentifier) else {
            completionHandler()
            return
        }
        
        switch action {
        case .play:
            if let episodeUrl = response.notification.request.content.userInfo["podcastUrl"] as? String,
                let url = URL.init(string: episodeUrl){
                print("Playiiiing \(episodeUrl)")
                PlayerHelper.sharedHelper.streamFromUrl(url: url)
            }
        default: break
        }
        
        completionHandler()
    }
}
