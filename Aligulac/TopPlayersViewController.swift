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
    var players = ObservableProperty<[Player]>([])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AligulacAPI.fetchPlayers().start(next: {
            players in
            self.players.put(players)
            return
        })
        
        players.values().start(next: {
            players in
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countElements(players.value)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = players.value[indexPath.row].tag
        return cell
    }
    
}

