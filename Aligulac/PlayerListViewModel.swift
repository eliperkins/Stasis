//
//  PlayerListViewModel.swift
//  Aligulac
//
//  Created by Eli Perkins on 12/18/14.
//  Copyright (c) 2014 eliperkins. All rights reserved.
//

import Foundation
import ReactiveCocoa

struct PlayerListViewModel {
    let players = ObservableProperty<[PlayerViewModel]>([])
    let client = AligulacAPI(token: "vXqui725YegPOtTf9k2l")
    
    let loadPlayersAction = Action<AligulacAPI, [Player]>(execute: {
        client in
        return client.fetchPlayers()
    })
    
    init() {
        loadPlayersAction.values
            .map {
                $0.map {
                    return PlayerViewModel(player: $0)
                }
            }
            .observe(players)
    }
}