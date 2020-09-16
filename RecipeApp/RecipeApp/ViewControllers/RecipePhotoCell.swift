//
//  RecipePhotoCell.swift
//  RecipeApp
//
//  Created by Jonathan Shoemaker on 8/20/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit

class RecipePhotoCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var recipeName: UILabel!
    @IBOutlet private weak var missedIngredients: UILabel!
    
    var missingIngredientsCount: Int? {
        didSet {
            if let missingIngredientsCount = missingIngredientsCount {
                if missingIngredientsCount > 0 {
                    missedIngredients.backgroundColor = .systemOrange
                    missedIngredients.text = "Missing Ingredients =  \(missingIngredientsCount)"
                    missedIngredients.numberOfLines = 0
                    missedIngredients.lineBreakMode = .byWordWrapping
                    missedIngredients.textAlignment = .center
                } else {
                    missedIngredients.text = nil
                }
            }
        }
    }
    
    var photo: Photo? {
      didSet {
        if let photo = photo {
            imageView.image = photo.image
            recipeName.text = photo.recipeName
            recipeName.backgroundColor = .systemYellow
            recipeName.textColor = .black
            recipeName.layer.cornerRadius = 10
            recipeName.layer.masksToBounds = true
            recipeName.numberOfLines = 0
            recipeName.lineBreakMode = .byWordWrapping
            recipeName.textAlignment = .center
            recipeName.sizeToFit()
        }
      }
    }
}

