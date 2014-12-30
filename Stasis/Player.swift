//
//  Player.swift
//  Stasis
//
//  Created by Eli Perkins on 11/7/14.
//  Copyright (c) 2014 Eli Perkins. All rights reserved.
//

import Argo

public struct Player {
    public let remoteID: Int
    public let name: String
    public let romanizedName: String?
    public let tag: String
    public let race: Race
    public let currentTeams: [Team]
    public let country: String

    public var team: Team {
        return currentTeams.first ?? Team.TeamlessTeam
    }
}

extension Player: Printable {
    public var description: String {
        return "Player: [\(team.shortname)] \(tag) (\(name))"
    }
}

extension Player: JSONDecodable {
    public static func create(remoteID: Int)(name: String)(romanizedName: String)(tag: String)(race: Race)(currentTeams: [Team])(country: String) -> Player {
        return Player(
            remoteID: remoteID,
            name: name,
            romanizedName: romanizedName,
            tag: tag,
            race: race,
            currentTeams: currentTeams,
            country: country
        )
    }
    
    public static func decode(j: JSONValue) -> Player? {
        return Player.create
            <^> j <| "id"
            <*> j <| "name"
            <*> j <| "romanized_name"
            <*> j <| "tag"
            <*> j <| "race"
            <*> j <|| "current_teams"
            <*> j <| "country"
    }
}

public enum Race {
    case Terran
    case Zerg
    case Protoss

    public static func fromString(race: String) -> Race {
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

extension Race: JSONDecodable {
    public static func create(string: String) -> Race {
        return Race.fromString(string)
    }
    
    public static func decode(j: JSONValue) -> Race? {
        return Race.create
            <^> j <| "race"
    }
}

public struct Team {
    public let remoteID: Int
    public let name: String
    public let shortname: String
    
    public static var TeamlessTeam: Team {
        return Team(remoteID: 0, name: "Teamless", shortname: "")
    }    
}

extension Team: JSONDecodable {
    public static func create(remoteID: Int)(name: String)(shortname: String) -> Team {
        return Team(remoteID: remoteID, name: name, shortname: shortname)
    }
    
    public static func decode(j: JSONValue) -> Team? {
        return Team.create
            <^> j <| "id"
            <*> j <| "name"
            <*> j <| "shortname"
    }
}

