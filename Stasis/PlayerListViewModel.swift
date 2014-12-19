//
//  PlayerListViewModel.swift
//  Stasis
//
//  Created by Eli Perkins on 12/18/14.
//  Copyright (c) 2014 eliperkins. All rights reserved.
//

import Foundation
import ReactiveCocoa

struct PlayerListViewModel {
    let players = ObservableProperty<[PlayerViewModel]>([])
    let client = AligulacAPI(token: "vXqui725YegPOtTf9k2l")
    
    let loadPlayersAction = Action<AligulacAPI, [PlayerViewModel]>({
        client in
        return client.fetchPlayers()
            .map {
                $0.map {
                    PlayerViewModel(player: $0)
                }
            }
        })
    
    init() {
        players <~ loadPlayersAction.values
    }
}