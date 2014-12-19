//
//  Player.swift
//  Aligulac
//
//  Created by Eli Perkins on 11/7/14.
//  Copyright (c) 2014 Eli Perkins. All rights reserved.
//

struct Player: Printable {
    let name: String
    let romanizedName: String?
    let tag: String
    let race: Race
    let team: Team
    let remoteID: Int
    let country: String

    static func transform(dict: [String : AnyObject]) -> Player {
        let name = dict["name"] as String
        let romanized = dict["romanized_name"] as? String
        let tag = dict["tag"] as String
        let race = Race.fromString(dict["race"] as String)
        let currentTeamsWrapped = dict["current_teams"] as [Dictionary<String,AnyObject>]
        var team: Team
        if let currentTeam = currentTeamsWrapped.first as Dictionary<String,AnyObject>! {
            team = Team.transform(currentTeam["team"] as Dictionary<String,AnyObject>)
        } else {
            team = Team.TeamlessTeam
        }
        let remoteID = dict["id"] as Int
        let country = dict["country"] as String

        return Player(
            name: name,
            romanizedName: romanized,
            tag: tag,
            race: race,
            team: team,
            remoteID: remoteID,
            country: country
        )
    }
    
    var description: String {
        return "Player: [\(team.shortname)] \(tag) (\(name))"
    }
}

enum Race {
    case Terran
    case Zerg
    case Protoss

    static func fromString(race: String) -> Race {
        switch race.lowercaseString {
        case "t":
            return .Terran
        case "z":
            return .Zerg
        case "p":
            return .Protoss
        default:
            return .Terran
        }
    }
}

struct Team {
    let name: String
    let shortname: String
    let remoteID: Int
    
    static var TeamlessTeam: Team {
        return Team(name: "Teamless", shortname: "", remoteID: 0)
    }
    
    static func transform(dict: Dictionary<String,AnyObject>) -> Team {
        let name = dict["name"] as String
        let shortname = dict["shortname"] as String
        let remoteID = dict["id"] as Int
        
        return Team(name: name, shortname: shortname, remoteID: remoteID)
    }
}
