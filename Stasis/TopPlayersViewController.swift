//
//  ViewController.swift
//  Stasis
//
//  Created by Eli Perkins on 11/6/14.
//  Copyright (c) 2014 Eli Perkins. All rights reserved.
//

import UIKit
import ReactiveCocoa

class TopPlayersViewController: UITableViewController {
    let viewModel = PlayerListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadPlayersAction.apply(viewModel.client).start()
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countElements(viewModel.players.value)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayerListCell", forIndexPath: indexPath) as PlayerListCell
        cell.viewModel = viewModel.players.value[indexPath.row]
        return cell
    }
    
}

