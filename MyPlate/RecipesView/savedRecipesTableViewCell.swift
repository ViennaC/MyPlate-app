//
//  savedRecipesTableViewCell.swift
//  Copyright © 2018 CS329E. All rights reserved.
//

import UIKit

class savedRecipesTableViewCell: UITableViewCell {
    @IBOutlet weak var savedRecipeNameLabel: UILabel!
    @IBOutlet weak var savedRecipeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
