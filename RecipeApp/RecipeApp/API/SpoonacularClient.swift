//
//  SpoonacularClient.swift
//  RecipeApp
//
//  Created by Jonathan Shoemaker on 8/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

class SpoonacularClient: NSObject {
    
    
    static let sharedInstance = SpoonacularClient()
    
    let URLScheme = "https"
    let baseURL = "api.spoonacular.com"
    let findRecipesByIngredientsURL = "/recipes/findByIngredients"
    let findRecipesByIdURL = "/recipes"
    
    var searchedRecipes: [String: JSON] = [:]
    

    let numberOfRecipesToReturn = 20

    
    func findRecipesByIngredients(ingredients: [String], onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        if let apiKey = ProcessInfo.processInfo.environment["apiKey"] {
            if !ingredients.isEmpty {
                var components = URLComponents()
                components.scheme = URLScheme
                components.host = baseURL
                components.path = findRecipesByIngredientsURL
                components.queryItems = [
                    URLQueryItem(name: "ingredients", value: ingredients.joined(separator: ",")),
                    URLQueryItem(name: "number", value: "\(numberOfRecipesToReturn)"),
                    URLQueryItem(name: "ranking", value: "1"),
                    URLQueryItem(name: "apiKey", value: apiKey)
                ]
                
                guard let url = components.url else {
                    let urlError = "Error in creating URL"
                    print(urlError)
                    onFailure(CustomError(msg: urlError))
                    return
                }
                
                let session = URLSession.shared
                let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
                    if(error != nil){
                        onFailure(error!)
                    } else{
                        do {
                            let result = try JSON(data: data!)
                            onSuccess(result)
                        } catch let error {
                            print("Error: \(error)")
                            onFailure(error)
                            return
                        }
                    }
                })
                task.resume()
            }
        } else {
            onFailure(CustomError(msg: "Error: API Key not found"))
        }
    }

    func findRecipeById(id: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        if let foundRecipe = searchedRecipes["\(id)"] {
            onSuccess(foundRecipe)
        } else {
            if let apiKey = ProcessInfo.processInfo.environment["apiKey"] {
                var components = URLComponents()
                components.scheme = URLScheme
                components.host = baseURL
                components.path = findRecipesByIdURL + "/\(id)/information"
                components.queryItems = [
                    URLQueryItem(name: "apiKey", value: apiKey)
                ]
                
                guard let url = components.url else {
                    let urlError = "Error in creating URL"
                    print(urlError)
                    onFailure(CustomError(msg: urlError))
                    return
                }
                
                let session = URLSession.shared
                let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
                    if(error != nil){
                        onFailure(error!)
                    } else{
                        do {
                            let result = try JSON(data: data!)
                            self.searchedRecipes["\(id)"] = result
                            onSuccess(result)
                        } catch let error {
                            print("Error: \(error)")
                            onFailure(error)
                            return
                        }
                    }
                })
                task.resume()
            } else {
                onFailure(CustomError(msg: "Error: API Key not found"))
            }
        }
    }
    
}
