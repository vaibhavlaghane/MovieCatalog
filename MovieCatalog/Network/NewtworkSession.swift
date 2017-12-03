//
//  NewtworkSession.swift
//  MovieCatalog
//
//  Created by vlaghane on 12/2/17.
//  Copyright © 2017 Drones. All rights reserved.
//

import UIKit

let notificationDataDownload = "NotificationDataDownload"

class NewtworkSession: NSObject {

    var dataArray = Array<Any>()
    
    func download_request(urlToRequest:String )
    {
        let url:URL = URL(string: urlToRequest)!
        let session = URLSession.shared
        
        var request =  URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
 
//        let paramString = "data=Hello"
//        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
 
        let task = session.downloadTask(with: request) {
            (  location,   response,   error) in
            
            guard let _:URL = location, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            let urlContents = try! String(contentsOf: location!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            
            guard let _:String = urlContents else {
                print("error")
                return
            }
            
            print(urlContents)
            
        }
        
        task.resume()
        
    }

    func dataRequest(urltoRequest:String)
    {
        let url:URL = URL(string: urltoRequest)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
 
        let task = session.dataTask(with: request as URLRequest) {
            (
              data,   response,   error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
          ////  NotificationCenter.default.post(name: Notification.Name(notificationDataDownload), object: nil, userInfo: nil )
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString ?? "default string if string empty")
            
            
            do {
                // Convert NSData to Dictionary where keys are of type String, and values are of any type
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any> // [String:Any]
                // Access specific key with value of type String
                //let str = json["key"] as! String
                
                let meta = json["meta"]
                let metaArr = meta as?  Array<Any >
                print(metaArr ?? "metaArr empty ")
                let data = json["data"] //as! Array<Dictionary>
                let dataArr = data as? Array<Any>
                print(dataArr ?? "dataArr empty ")
                guard let dArr = dataArr else{return}
               
                for (_, element ) in (dArr.enumerated()){

                    
                    self.dataArray.append(element)
                }
            } catch {
                // Something went wrong
            }
            
            
            NotificationCenter.default.post(name: Notification.Name(notificationDataDownload), object: nil, userInfo: nil )
        }
        
        task.resume()
        
    }
    
 
}
