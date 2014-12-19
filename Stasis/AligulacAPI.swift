//
//  AligulacAPI.swift
//  Stasis
//
//  Created by Eli Perkins on 11/6/14.
//  Copyright (c) 2014 Eli Perkins. All rights reserved.
//

import Foundation
import ReactiveCocoa
import LlamaKit
import CMDQueryStringKit

final class AligulacAPI {
    let baseURL = NSURL(string:"http://www.aligulac.com/api/v1/")!
    let token: String
    
    required init(token: String) {
        self.token = token
    }
    
    func signedRequest(path: String, parameters: [String : AnyObject]) -> NSMutableURLRequest {
        var signedParams = parameters
        signedParams["apikey"] = token
        let pathString = path + "?" + CMDQueryStringSerialization.queryStringWithDictionary(signedParams)
        let URL = NSURL(string: pathString, relativeToURL: baseURL)!
        return NSMutableURLRequest(URL: URL)
    }
}

typealias JSONDictionary = [String:AnyObject]

extension AligulacAPI {
    func fetchPlayers() -> ColdSignal<[Player]> {
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
            .map { (data, response) in
                return data
            }
            .map(self.decodeJSON)
            .map { $0!["objects"] as [JSONDictionary] }
            .map { $0.map(Player.transform) }
    }
    
    internal func stubbedPlayersJSON(request: NSURLRequest) -> ColdSignal<(NSData, NSURLResponse)> {
        let path = NSBundle.mainBundle().pathForResource("players", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let response = NSHTTPURLResponse(URL: request.URL, MIMEType: "application/json", expectedContentLength: 0, textEncodingName: nil)
        let tuple: (NSData, NSURLResponse) = (data, response)
        return ColdSignal.single(tuple)
    }
    
    internal func decodeJSON(data: NSData) -> JSONDictionary? {
        return NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as? JSONDictionary
    }
    
    internal func extractObjects(JSON: [String : AnyObject]) -> Result<[JSONDictionary]> {
        if ((JSON["objects"]) != nil) {
            return success(JSON["objects"] as [JSONDictionary])
        } else {
            return failure()
        }
    }
}