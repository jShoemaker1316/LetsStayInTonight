//
//  PhotoStruct.swift
//  RecipeApp
//
//  Created by Jonathan Shoemaker on 8/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit
import Foundation

struct Photo {
    var recipeName: String
    var image: UIImage

    init(recipeName: String, image: UIImage?) {
      self.recipeName = recipeName
      self.image = image ?? UIImage()
    }
}
