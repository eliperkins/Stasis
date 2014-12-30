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
import Argo

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
            .tryMap { (data, response) -> Result<AnyObject> in
                return try {
                    NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: $0)
                }
            }
            .tryMap { (json) -> Result<[JSONValue]> in
                let parsedJSON = JSONValue.parse(json)
                switch parsedJSON {
                case let .JSONObject(o):
                    // Aligulac API serializes root objects under the key "objects"
                    if let valueExists = o["objects"] {
                        switch valueExists {
                        case let .JSONArray(array):
                            return success(array)
                            
                        default:
                            break
                        }
                    }
                    
                default:
                    break
                }
                
                return failure("Failed to get array as root JSON object")
            }
            .tryMap { (playersJSON) -> Result<[Player]> in
                // TODO: see if we can get nil players as a `failure`
                success(playersJSON.map { Player.decode($0)! })
            }
    }
    
    internal func stubbedPlayersJSON(request: NSURLRequest) -> ColdSignal<(NSData, NSURLResponse)> {
        let path = NSBundle.mainBundle().pathForResource("players", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let response = NSHTTPURLResponse(URL: request.URL, MIMEType: "application/json", expectedContentLength: 0, textEncodingName: nil)
        let tuple: (NSData, NSURLResponse) = (data, response)
        return ColdSignal.single(tuple)
    }
    
    
    typealias JSONDictionary = [String:AnyObject]

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