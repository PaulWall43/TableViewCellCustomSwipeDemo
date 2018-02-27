//
//  RightLeftTableViewCell.swift
//  TableViewCellsSwipeStuff
//
//  Created by Paul Wallace on 2/26/18.
//  Copyright © 2018 Paul Wallace. All rights reserved.
//

import UIKit

class RightLeftTableViewCell: UITableViewCell {
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var leftStretchView: UIView!
    @IBOutlet weak var rightStretchView: UIView!
    @IBOutlet weak var leftStretchViewWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var rightStretchViewWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        centerLabel.alpha = 0
    }
    
    
}
