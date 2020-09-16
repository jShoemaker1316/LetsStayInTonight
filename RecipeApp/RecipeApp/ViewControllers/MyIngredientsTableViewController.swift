//
//  MyIngredientsTableViewController.swift
//  RecipeApp
//
//  Created by Jonathan Shoemaker on 8/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyIngredientsTableViewController: UITableViewController, UITextFieldDelegate {

    var myIngredientsList: [Ingredient] = []
    var recipeBasicList: [RecipeBasics] = []
    
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBAction func addIngredient(_ sender: Any) {
        addIngredientInTextField()
    }
    @IBAction func searchButton(_ sender: UIButton) {
            if myIngredientsList.isEmpty {
                            let alert = UIAlertController(title: "Warning", message: "Please add an ingredient before searching", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            sender.isEnabled = false
                            sender.backgroundColor = .systemTeal
                            sender.setTitle("Loading...", for: .disabled)
                            let ingredients = myIngredientsList.map{$0.name}
                            let myGroup = DispatchGroup()
                            myGroup.enter()
                            SpoonacularClient.sharedInstance.findRecipesByIngredients(ingredients: ingredients, onSuccess: { json in
                                for (index, subJson):(String, JSON) in json {
                                    DispatchQueue.main.async {
                                        sender.setTitle("Loading... (\(index)/\(json.count)", for: .disabled)
                                    }
                                    self.recipeBasicList.append(RecipeBasics(id: subJson["id"].int!, name: subJson["title"].string!, image: subJson["image"].string!, missingIngredientsCount: subJson["missedIngredientCount"].int!))
                                }
                                myGroup.leave()
                            }, onFailure: { error in
                                sender.isEnabled = true
                                sender.backgroundColor = .systemOrange
                                sender.setTitle("Search", for: .normal)
                                let alert = UIAlertController(title: "Error", message: "\(error). Please try again!", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                myGroup.leave()
                            })
                            myGroup.notify(queue: .main) {
                                if !self.recipeBasicList.isEmpty {
                                    self.performSegue(withIdentifier: "showRecipesSegue", sender: nil)
                                    self.recipeBasicList = []
                                }
                                sender.backgroundColor = .green
                                sender.setTitle("Search", for: .normal)
                                sender.isEnabled = true
                            }
                        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTextField.placeholder = "Ingredient Name"
        tableView.keyboardDismissMode = .onDrag
        self.ingredientTextField.delegate = self
    }
    
    func addIngredientInTextField() {
        if ingredientTextField.text != nil && ingredientTextField.text != "" {
            let ingredientName = ingredientTextField.text
            if !myIngredientsList.contains(where: {$0.name == ingredientName}) {
                let newIngredient = Ingredient(name: ingredientName!)
                myIngredientsList.append(newIngredient)
                ingredientTextField.text = nil
                tableView.beginUpdates()
                let currentIndex = myIngredientsList.count - 1 > 0 ? myIngredientsList.count - 1 : 0
                tableView.insertRows(at: [IndexPath(row: currentIndex, section: 0)], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientTextField.resignFirstResponder()
        addIngredientInTextField()
        return true
    }

// MARK: tableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myIngredientsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.text = myIngredientsList[indexPath.row].name
        cell.textLabel?.font = UIFont(name: "Chalkduster", size: 15)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           self.myIngredientsList.remove(at: indexPath.row)
           tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

// MARK: SortRecipeList
    func sortRecipeListByMissedIngredients() {
        self.recipeBasicList.sort(by: {$0.missingIngredientsCount < $1.missingIngredientsCount})
    }

// MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let recipeGeneralCollection = segue.destination as? RecipeSearchCollectionViewController {
            sortRecipeListByMissedIngredients()
            recipeGeneralCollection.recipes = self.recipeBasicList
            recipeGeneralCollection.viewTitle = "Found Recipes"
        }
    }

}

