//
//  PlayerListCell.swift
//  Aligulac
//
//  Created by Eli Perkins on 12/19/14.
//  Copyright (c) 2014 eliperkins. All rights reserved.
//

import UIKit
import ReactiveCocoa

class PlayerListCell: UITableViewCell {
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var raceImageView: UIImageView!
    
    var viewModel: PlayerViewModel? {
        didSet {
            tagLabel.text = viewModel?.player.tag ?? ""
            teamLabel.text = viewModel?.player.team.shortname ?? ""
            raceImageView.image = viewModel?.raceImage
            flagImageView.image = viewModel?.flagImage
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
