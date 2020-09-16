//
//  RecipeInfoTableViewCell.swift
//  RecipeApp
//
//  Created by Jonathan Shoemaker on 8/23/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit

class RecipeInfoTableViewCell: UITableViewCell {
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeName: UILabel!
    @IBOutlet var servings: UILabel!
    @IBOutlet var preparationInMinutes: UILabel!
    @IBOutlet var cookingInMinutes: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
