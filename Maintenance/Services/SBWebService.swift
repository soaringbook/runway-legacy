//
//  SoaringBookClient.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation

enum SBWebServiceError: ErrorType {
    case Success
    case Failure
    case Unauthenticated
}

class SBWebService: NSObject {
    
    // MARK: - Privates
    
    private var session: NSURLSession
    
    // MARK: - Initialization
    
    override init() {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.HTTPMaximumConnectionsPerHost = 1
        session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        super.init()
    }
    
    // MARK: - Actions
    
    func cancel() {
        session.invalidateAndCancel()
    }
    
    // MARK:- Authenticate
    
    func authenticate(token token: String, callback: (SBWebServiceError) -> ()) {
        let request = authenticatedRequest(path: "gliders.json", method: "HEAD", token: token)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error == nil {
                callback(.Success)
            } else {
                callback(.Unauthenticated)
            }
        }
        task.resume()
    }
    
    // MARK: - Requests
    
    private func authenticatedRequest(path path: String, method: String = "GET", token: String? = nil) -> NSMutableURLRequest {
        let hostProtocol = SBConfiguration.sharedInstance.apiProtocol
        let host = SBConfiguration.sharedInstance.apiHost
        let URL = NSURL(string: NSString(format: "\(hostProtocol)://\(host)/%@", path) as String)
        
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = method
        
        let tokenToEncode = token ?? SBKeychain.sharedInstance.token ?? ""
        request.addValue("Token token=\(tokenToEncode)", forHTTPHeaderField: "Authorization")
        request.addValue("application/vnd.soaringbook.v\(SBConfiguration.sharedInstance.apiVersion)", forHTTPHeaderField: "Accept")
        
        return request
    }
}