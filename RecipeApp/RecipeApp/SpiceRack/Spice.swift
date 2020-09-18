//
//  Spice.swift
//  RecipeApp
//
//  Created by Jonathan Shoemaker on 9/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import Foundation
class Spice {
    var title: String
    var subtitle: String
    var need: Bool

    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.need = false
    }
}
