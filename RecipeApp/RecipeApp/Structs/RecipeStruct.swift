//
//  RecipeStruct.swift
//  RecipeApp
//
//  Created by Jonathan Shoemaker on 8/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import Foundation

struct Ingredient: Codable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

struct RecipeBasics: Codable {
    var id: Int
    var name: String
    var image: String
    var missingIngredientsCount: Int
    
    init(id: Int, name: String, image: String, missingIngredientsCount: Int) {
        self.id = id
        self.name = name
        self.image = image
        self.missingIngredientsCount = missingIngredientsCount
    }
}

struct Recipe: Codable {
    var info: RecipeInfo
    var ingredients: RecipeIngredients
    var instructions: RecipeInstructions

    init(info: RecipeInfo, ingredients: RecipeIngredients, instructions: RecipeInstructions) {
        self.info = info
        self.ingredients = ingredients
        self.instructions = instructions
    }
}

struct RecipeInfo: Codable {
    var id: Int
    var name: String
    var image: String
    var servings: Int
    var preparationInMinutes: Int
    var cookingInMinutes: Int
    
    init(id: Int, name: String, image: String, servings: Int, preparationInMinutes: Int, cookingInMinutes: Int) {
        self.id = id
        self.name = name
        self.image = image
        self.servings = servings
        self.preparationInMinutes = preparationInMinutes
        self.cookingInMinutes = cookingInMinutes
    }
}

struct RecipeIngredient: Codable {
    var id: Int
    var description: String
    
    init(id: Int, description: String) {
        self.id = id
        self.description = description
    }
}

struct RecipeIngredients: Codable {
    var ingredients: [RecipeIngredient]
    
    init(ingredients: [RecipeIngredient]) {
        self.ingredients = ingredients
    }
}

struct RecipeInstructionStep: Codable {
    var stepNumber: Int
    var stepDescription: String
    
    init(stepNumber: Int, stepDescription: String) {
        self.stepNumber = stepNumber
        self.stepDescription = stepDescription
    }
}

struct RecipeInstructions: Codable {
    var instructions: [RecipeInstructionStep]
    
    init(instructions: [RecipeInstructionStep]) {
        self.instructions = instructions
    }
}
