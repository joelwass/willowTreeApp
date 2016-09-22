//
//  API.swift
//  WillowTreeNames
//
//  Created by Joel Wasserman on 9/21/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

class API: NSObject {
    
    private static let singleton = API()
    public var returnedData:JSON?
    
    class func sharedInstance() -> API {
        return singleton
    }
    
    func requestWithMethod(method: String, url: NSString, parameters:[String:AnyObject]?) -> NSMutableURLRequest {
        
        let jsonFileURL = NSURL(string: url as String)
        let urlRequest = NSMutableURLRequest(URL: jsonFileURL!)
        urlRequest.HTTPMethod = method
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
    
    func getNames(completion: (result: JSON) -> Void) {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let urlRequest = requestWithMethod("GET", url: "http://api.namegame.willowtreemobile.com/", parameters: nil)
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {(data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                let json: JSON = "Error: did not receive data"
                completion(result: json)
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            let json = JSON(data: responseData)
            self.returnedData = json
            completion(result: json)
        })
        task.resume()
    }
    
}


