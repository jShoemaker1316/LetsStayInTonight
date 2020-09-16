//
//  FullRecipeTableViewController.swift
//  RecipeApp
//
//  Created by Jonathan Shoemaker on 8/21/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit
import SwiftyJSON

class FullRecipeTableViewController: UITableViewController {
    
    var recipe: Recipe?
    var viewTitle: String = ""
    
    let recipeInfoSection = 0
    let recipeIngredientsSection = 1
    let recipeInstructionsSection = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewTitle
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
      
        let recipeInfoCell = UINib(nibName: "RecipeInfoCell", bundle: nil)
        tableView.register(recipeInfoCell, forCellReuseIdentifier: "recipeInfoCell")
    }

// MARK: tableView

    override func numberOfSections(in tableView: UITableView) -> Int {
//1. recipe 2. ingredients 3. directions
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == recipeIngredientsSection {
            return recipe!.ingredients.ingredients.count
        } else if section == recipeInstructionsSection {
            return recipe!.instructions.instructions.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == recipeIngredientsSection {
            return "Ingredients"
        } else if section == recipeInstructionsSection {
            return "Instructions"
        } else {
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch(indexPath.section) {
        case recipeInfoSection:
            if let recipeInfoCell = tableView.dequeueReusableCell(withIdentifier: "recipeInfoCell", for: indexPath) as? RecipeInfoTableViewCell {
                let recipeInfo = recipe!.info
                recipeInfoCell.recipeName.text = recipeInfo.name
                if recipeInfo.servings > 0 {
                    recipeInfoCell.servings.text = "\(recipeInfo.servings)"
                } else {
                    recipeInfoCell.servings.text = "N/A"
                }
                if recipeInfo.preparationInMinutes > 0 {
                    recipeInfoCell.preparationInMinutes.text = "\(recipeInfo.preparationInMinutes) mins"
                } else {
                    recipeInfoCell.preparationInMinutes.text = "N/A"
                }
                if recipeInfo.cookingInMinutes > 0 {
                    recipeInfoCell.cookingInMinutes.text = "\(recipeInfo.cookingInMinutes) mins"
                } else {
                    recipeInfoCell.cookingInMinutes.text = "N/A"
                }

                var recipeImage: UIImage?
                let photoLink = recipeInfo.image
                if var httpParkLink = URLComponents(string: photoLink) {
                    httpParkLink.scheme = "https"
                    if let httpsParkLink = httpParkLink.string {
                        do {
                            let data = try Data(contentsOf: URL(string: httpsParkLink)!)
                            recipeImage = UIImage(data: data) ?? nil
                        } catch {
                            print(error)
                        }
                    }
                }

                recipeInfoCell.recipeImageView?.image = recipeImage

                cell = recipeInfoCell
            } else {
                print("Unable to dequeue instance of RecipeInfoTableViewCell.")
            }
            
// MARK: Recipe Sections
            
        case recipeIngredientsSection:
            if let recipeIngredientsCell = tableView.dequeueReusableCell(withIdentifier: "recipeBasicCell", for: indexPath) as? UITableViewCell {
                let recipeIngredients = recipe!.ingredients
                recipeIngredientsCell.textLabel?.text = recipeIngredients.ingredients[indexPath.row].description
                cell = recipeIngredientsCell
            }  else {
               print("Unable to dequeue instance of UITableViewCell with identifier 'recipeBasicCell'.")
            }
            
        case recipeInstructionsSection:
            if let recipeIngredientsCell = tableView.dequeueReusableCell(withIdentifier: "recipeSubtitleCell", for: indexPath) as? UITableViewCell {
                let recipeInstruction = recipe!.instructions.instructions[indexPath.row]
                recipeIngredientsCell.textLabel?.text = "Step \(recipeInstruction.stepNumber)"
                recipeIngredientsCell.detailTextLabel?.text = "\(recipeInstruction.stepDescription)"
                cell = recipeIngredientsCell
            }  else {
               print("Unable to dequeue instance of UITableViewCell with identifier 'recipeSubtitleCell'.")
            }
            
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "recipeBasicCell", for: indexPath)
        }
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.lineBreakMode = .byWordWrapping
        cell?.textLabel?.textAlignment = .left

        return cell!
    }

}

