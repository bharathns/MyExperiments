//
//  FileService.swift
//  mvvm1
//
//  Created by Bharath Nadampalli on 31/07/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit
private let timeoutInterval = 120.0
typealias ServiceCompletion              = (_ response: Any?, _ error: NSError?) -> Void
typealias JSONDictionary = [String: Any]
typealias JSONArray = [JSONDictionary]

class Formula1Service: NSObject {
    
    class func drivers(page : Int, limit : Int, completion: @escaping ServiceCompletion) {

        let urlString = "https://ergast.com/api/f1/drivers.json?limit=\(limit)&offset=\(page*limit)"

        guard let urlSession:URLSession  = SessionManager.shared.urlSession, let url: URL = URL(string:urlString), let authHeader = authHeader() else {
            return
        }
        let request = NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        //request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        
        let httprequest = urlSession.dataTask(with: request as URLRequest){ (data, response, error) in
            if error != nil {
                print(error ?? "nil")
            } else {
                completion(data,error as NSError?)
            }
        }
        httprequest.resume()
    }
    
    class func authHeader() -> String? {


        return ""
    }
}
