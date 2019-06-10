//
//  RecipesTableViewCell.swift
//  Copyright © 2018 CS329E. All rights reserved.
//

import UIKit

class RecipesTableViewCell: UITableViewCell {
    @IBOutlet weak var RecipeNameLabel: UILabel!
    @IBOutlet weak var RecipeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
