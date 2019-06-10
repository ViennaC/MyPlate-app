//
//  BMITableViewCell.swift
//  Copyright © 2018 CS329E. All rights reserved.
//

import UIKit

class BMITableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    
}
