//
//  BounceCourtInfoTableViewCell.swift
//  Bounce
//
//  Created by Bounce Team on 12/14/14.
//  Copyright (c) 2014 NYUPoly. All rights reserved.
//

import UIKit

class BounceCourtInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var courtNameLabel: UILabel!
    @IBOutlet weak var courtDistanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
