//
//  PlayerViewModel.swift
//  Aligulac
//
//  Created by Eli Perkins on 12/18/14.
//  Copyright (c) 2014 eliperkins. All rights reserved.
//

import Foundation

struct PlayerViewModel {
    let player: Player
    
    func inGameName() -> String {
        switch player.team.name {
        case "Teamless":
            return player.tag
            
        case "Team Liquid":
            return "\(player.team.shortname)`\(player.tag)"
            
        default:
            return "[\(player.team.shortname)] \(player.tag)"
        }
    }
}