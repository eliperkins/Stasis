//
//  ViewController.swift
//  Aligulac
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
        
        viewModel.players.values().on {
            _ in
            self.tableView.reloadData()
        }
        
        viewModel.loadPlayersAction
            .execute(viewModel.client)
            .on(
                subscribed: {},
                next: {
                    _ in
                    self.tableView.reloadData()
                },
                error: {
                    error in
                    print(error)
                },
                completed: {}, terminated: {}, disposed: {}
            )

    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countElements(viewModel.players.value)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = viewModel.players.value[indexPath.row].inGameName()
        return cell
    }
    
}

