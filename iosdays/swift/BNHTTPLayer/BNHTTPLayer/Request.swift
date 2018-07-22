//
//  Request.swift
//  BNHTTPLayer
//
//  Created by Bharath Nadampalli on 20/07/17.
//
//

import UIKit



/**
 The standard HTTP Verbs
 */
public enum HTTPMethod: String {
    case Get        = "GET"
    case Put        = "PUT"
    case Post       = "POST"
    case Delete     = "DELETE"
    case Options     = "OPTIONS"
}

protocol Resource: {
    
}

protocol Request {
    
}

class NetworkRequest: NSObject, Request {
    
    
}
