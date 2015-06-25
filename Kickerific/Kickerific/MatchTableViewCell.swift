//
//  MatchTableViewCell.swift
//  Kickerific
//
//  Created by Mario on 23.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit
import Parse

class MatchTableViewCell: UITableViewCell {
        
    @IBOutlet var teamname1: UILabel?
    @IBOutlet var teamname2: UILabel?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
