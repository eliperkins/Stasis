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

let STUB = true

public struct AligulacAPI {
    public static let baseURL = NSURL(string:"http://www.aligulac.com/api/v1/")!
}

public extension AligulacAPI {
    public static func fetchPlayers() -> ColdSignal<[Player]> {
        let endpoint =  NSURL(string: "player/?apikey=vXqui725YegPOtTf9k2l&current_rating__isnull=false&current_rating__decay__lt=4&order_by=-current_rating__rating&limit=10", relativeToURL: baseURL)!
        let request = NSMutableURLRequest(URL: endpoint)
        
        let data = STUB ? stubbedPlayersJSON() : NSURLSession.sharedSession().rac_dataWithRequest(request)
        
        return data
            .tryMap(self.dataToJSON)
            .tryMap(self.extractObjects)
            .map { $0.map(Player.transform) }
    }
    
    public static func stubbedPlayersJSON() -> ColdSignal<(NSData, NSURLResponse)> {
        let path = NSBundle.mainBundle().pathForResource("players", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        
        let endpoint =  NSURL(string: "player/?apikey=vXqui725YegPOtTf9k2l&current_rating__isnull=false&current_rating__decay__lt=4&order_by=-current_rating__rating&limit=10", relativeToURL: baseURL)!
        let response = NSHTTPURLResponse(URL: endpoint, MIMEType: "application/json", expectedContentLength: 0, textEncodingName: nil)
        let tuple: (NSData, NSURLResponse) = (data, response)
        return ColdSignal.single(tuple)
    }
    
    public static func dataToJSON(data: NSData, response: NSURLResponse) -> Result<[String : AnyObject]> {
        let opt: NSJSONReadingOptions = .AllowFragments
        let err: NSErrorPointer = nil
 
        return success(NSJSONSerialization.JSONObjectWithData(data, options: opt, error: err)! as [String : AnyObject])
    }
    
    public static func extractObjects(JSON: [String : AnyObject]) -> Result<[[String : AnyObject]]> {
        if ((JSON["objects"]) != nil) {
            return success(JSON["objects"] as [[String : AnyObject]])
        } else {
            return failure()
        }
    }
}