//
//  PlayerViewModel.swift
//  Aligulac
//
//  Created by Eli Perkins on 12/18/14.
//  Copyright (c) 2014 eliperkins. All rights reserved.
//

import Foundation
import UIKit

struct PlayerViewModel {
    let player: Player
    
    var fullTag: String {
        switch player.team.name {
        case "Teamless":
            return player.tag
            
        case "Team Liquid":
            return "\(player.team.shortname)`\(player.tag)"
            
        default:
            return "[\(player.team.shortname)] \(player.tag)"
        }
    }
    
    var raceImage: UIImage? {
        switch player.race {
        case .Terran:
            return UIImage(named: "T")
        case .Protoss:
            return UIImage(named: "P")
        case .Zerg:
            return UIImage(named: "Z")
        }
    }
    
    var flagImage: UIImage? {
        switch player.country {
        case "KR":
            return UIImage(named: "kr")
        default:
            return nil
        }
    }
}