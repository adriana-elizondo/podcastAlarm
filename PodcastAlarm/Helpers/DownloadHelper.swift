//
//  DownloadHelper.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 15/12/2016.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit

class DownloadHelper : NSObject{
    static let sharedInstance = DownloadHelper()
    
    lazy var pathToDirectory : URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let episodeDirectory = documentsDirectory?.appendingPathComponent("Episodes")
        
        if let directoryUrl = episodeDirectory as URL?{
            //If directory doesnt exist create it first
            if !FileManager.default.fileExists(atPath: directoryUrl.path){
                do{
                    try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
                }catch{
                    //Do something here
                }
            }
            
            return directoryUrl
        }
        
        return documentsDirectory!
    }()

    func downloadPodcastFromUrl(stringUrl: String){
        if let url = URL.init(string: stringUrl){
            let urlSession = URLSession.init(configuration:URLSessionConfiguration.background(withIdentifier: url.lastPathComponent), delegate: self, delegateQueue: OperationQueue.main)
            urlSession.downloadTask(with: url).resume()
        }
    }
}

extension DownloadHelper : URLSessionDelegate, URLSessionDownloadDelegate{
    //MARK: Delegate methods
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Session \(session) download task \(downloadTask) finished downloading to URL \(location)\n")
        // Move the file to a new URL
        do {
            try FileManager.default.moveItem(at: location, to: pathToDirectory.appendingPathComponent(session.configuration.identifier ?? "default.mp3"))
            print("moved to \(pathToDirectory.appendingPathComponent(session.configuration.identifier!))")
        } catch {
            // ...Do something
            print("couldnt move item \(error)")
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let completion = appDelegate.completionHandlers[session.configuration.identifier ?? ""]{
            completion()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("Session \(session) download task \(downloadTask) wrote an additional \(bytesWritten) bytes (total \(totalBytesWritten) bytes) out of an expected \(totalBytesExpectedToWrite) bytes.\n")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("Session \(session) download task \(downloadTask) resumed at offset \(fileOffset) bytes out of an expected \(expectedTotalBytes) bytes.\n")
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("Finished event called")
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let completion = appDelegate.completionHandlers[session.configuration.identifier ?? "default.mp3"]{
            completion()
        }
    }
}
