//
//  NewtworkSession.swift
//  MovieCatalog
//
//  Created by vlaghane on 12/2/17.
//  Copyright © 2017 Drones. All rights reserved.
//

import UIKit

class NetworkSession: NSObject {

    var dataArray = Array<Any>()
    var dataArrayOnlyMovieNames = Array<Any>()
    var movieLocationDictionary = Dictionary<String, Array<String>>()
    
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
                Utility.showAlertMessage("Failed to Download the Content", withTitle: "Download Update", onClick: {
                    //
                })
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print(dataString ?? "default string if string empty")
            
            
            do {
                // Convert NSData to Dictionary where keys are of type String, and values are of any type
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any> // [String:Any]
                // Access specific key with value of type String
                
                let meta = json["meta"]
                let metaArr = meta as?  Array<Any >
                //print(metaArr ?? "metaArr empty ")
                let data = json["data"] //as! Array<Dictionary>
                let dataArr = data as? Array<Any>
                //print(dataArr ?? "dataArr empty ")
                guard let dArr = dataArr else{return}
               
                for (_, element ) in (dArr.enumerated()){
                    self.dataArray.append(element)
                }
 
                CoreDataManager.sharedInstance.updateCoreData(inpData: self.dataArray) //
 
            } catch {
                // Something went wrong
                print("JSON could not be parsed")
            }
            NotificationCenter.default.post(name: Notification.Name(Constants.notificationDataDownload), object: nil, userInfo: ["JSONArray": self.dataArray] )
        }
        
        task.resume()
        
    }
    
 
}
