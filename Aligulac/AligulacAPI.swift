//
//  AligulacAPI.swift
//  Aligulac
//
//  Created by Eli Perkins on 11/6/14.
//  Copyright (c) 2014 Eli Perkins. All rights reserved.
//

import Foundation
import ReactiveCocoa
import LlamaKit
import CMDQueryStringKit

public final class AligulacAPI {
    public let baseURL = NSURL(string:"http://www.aligulac.com/api/v1/")!
    public let token: String
    
    public required init(token: String) {
        self.token = token
    }
    
    public func signedRequest(path: String, parameters: [String : AnyObject]) -> NSMutableURLRequest {
        var signedParams = parameters
        signedParams["apikey"] = token
        let pathString = path + "?" + CMDQueryStringSerialization.queryStringWithDictionary(signedParams)
        let URL = NSURL(string: pathString, relativeToURL: baseURL)!
        return NSMutableURLRequest(URL: URL)
    }
}

public extension AligulacAPI {
    public func fetchPlayers() -> ColdSignal<[Player]> {
        let parameters = [
            "current_rating__isnull" : "false",
            "current_rating__decay__lt" : 4,
            "order_by" : "-current_rating__rating",
            "limit" : 10
        ]
        let request = signedRequest("player", parameters: parameters)

        let requestSignal = stubbedPlayersJSON(request)
//        let requestSignal = NSURLSession.sharedSession().rac_dataWithRequest(request)
    
        return requestSignal
            .map { (data, response) -> NSData in
                return data
            }
            .map {
                (data: NSData) -> [String : AnyObject]? in
                let opt: NSJSONReadingOptions = .AllowFragments
                
                return NSJSONSerialization.JSONObjectWithData(data, options: opt, error: nil) as [String : AnyObject]?
            }
            .map { $0!["objects"] as [[String : AnyObject]] }
            .map { $0.map(Player.transform) }
    }
    
    public func stubbedPlayersJSON(request: NSURLRequest) -> ColdSignal<(NSData, NSURLResponse)> {
        let path = NSBundle.mainBundle().pathForResource("players", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let response = NSHTTPURLResponse(URL: request.URL, MIMEType: "application/json", expectedContentLength: 0, textEncodingName: nil)
        let tuple: (NSData, NSURLResponse) = (data, response)
        return ColdSignal.single(tuple)
    }
    
    public func dataToJSON(data: NSData) -> Result<[String : AnyObject]> {
        let opt: NSJSONReadingOptions = .AllowFragments
        
        return try {
            error in
            NSJSONSerialization.JSONObjectWithData(data, options: opt, error: error) as? [String : AnyObject]
        }
    }
    
    public func extractObjects(JSON: [String : AnyObject]) -> Result<[[String : AnyObject]]> {
        if ((JSON["objects"]) != nil) {
            return success(JSON["objects"] as [[String : AnyObject]])
        } else {
            return failure()
        }
    }
}