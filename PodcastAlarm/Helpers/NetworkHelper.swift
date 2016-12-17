//
//  NetworkHelper.swift
//  PodcastAlarm
//
//  Created by Adriana Elizondo on 11/19/16.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation

import UIKit

public let baseUrl = "https://itunes.apple.com/search?term="
public let defaultParameters = "&entity=podcast"

public typealias RequestResponse = (Bool, Any?, Error?) -> Void

enum Encoding{
    case JSON, XML
}

class NetworkHelper{
    static func getDataWithUrl(stringUrl: String, encoding: Encoding, completion: @escaping RequestResponse){
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        guard let url = URL.init(string: stringUrl) else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return
        }
        
        requestWith(url: URLRequest.init(url: url), encoding: encoding, completion: completion)
    }
    
    static func requestWith(url: URLRequest, encoding: Encoding,completion: @escaping RequestResponse){
        let session = URLSession.init(configuration: URLSessionConfiguration.default)
        session.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                var decodedResponse : Any?
                switch encoding{
                case .JSON:
                    decodedResponse = try? JSONSerialization.jsonObject(with: data, options: [])
                    break
                case .XML:
                    decodedResponse = data
                    break
                }
                if let code = (response as? HTTPURLResponse)?.statusCode , 200...299 ~= code{
                    completion(true, decodedResponse, nil)
                }else{
                    completion(false, nil, error)
                }
            }else{
                completion(false, nil, error)
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            }.resume()
    }
    
}
