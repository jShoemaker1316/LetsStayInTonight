//
//  SpiceViewController.swift
//  RecipeApp
//
//  Created by Jonathan Shoemaker on 9/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import UIKit

class SpiceViewController: UITableViewController {

    private var taskList = [Spice]()
    let spicesController = SpiceController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "The Spice Rack"
        self.fetchAllSpice()
        self.setupLongPressGesture()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_task", for: indexPath) as! SpiceCell

        if indexPath.row < taskList.count
        {
            let task = taskList[indexPath.row]
            cell.spiceTitle?.text = task.title
            cell.spiceSubtitle?.text = task.subtitle

            let accessory: UITableViewCell.AccessoryType = task.need ? .checkmark : .none
            cell.accessoryType = accessory
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row < taskList.count
        {
            let taskTemp = taskList[indexPath.row]
            taskTemp.need = !taskTemp.need

            spicesController.updateSpiceGotIt(task: taskTemp)

            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if indexPath.row < taskList.count
        {
            self.deleteSpice(indexPath: indexPath)
        }
    }

    @IBAction func onAddClick(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(
            title: "Spice Name (e.g. Sage, Oregano, Cayenne Pepper)",
            message: "Type of Spice (e.g. Mediterranean, Italian, Mexican/Cajun/Indian",
            preferredStyle: .alert)


        alert.addTextField{(textField : UITextField) in
            textField.placeholder = "What Spice Do You Already Have?"
        }
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Dishes Spice is Meant For"
        }


        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))


        alert.addAction(UIAlertAction(title: "Add Spice", style: .default, handler: { _ in
            if let title = alert.textFields?[0].text, let subtitle = alert.textFields?[1].text
            {
                self.addSpice(title: title, subtitle: subtitle, rNeed: false , insert: true)

            }
        }))


        self.present(alert, animated: true, completion: nil)
    }

    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        self.tableView.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.displayEditAlert(indexPath: indexPath)
            }
        }
    }

    private func displayEditAlert(indexPath: IndexPath){


        let alert = UIAlertController(
            title: "Edit Spice",
            message: "Enter the spice details",
            preferredStyle: .alert)


        alert.addTextField{(textField : UITextField) in
            textField.text = self.taskList[indexPath.row].title
        }
        alert.addTextField { (textField: UITextField) in
            textField.text = self.taskList[indexPath.row].subtitle
        }


        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))


        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let title = alert.textFields?[0].text, let subtitle = alert.textFields?[1].text
            {
                self.editSpice(indexPath: indexPath, title: title, subtitle: subtitle)
            }
        }))


        self.present(alert, animated: true, completion: nil)
    }

    private func addSpice(title: String, subtitle: String, rNeed: Bool, insert: Bool)
    {

        let newIndex = taskList.count


        var newT = Spice(title: title, subtitle: subtitle)
        if (insert){
  
            spicesController.insertSpice(newTask : newT)
        }else{
            newT.need = rNeed
        }
        taskList.append(newT)


        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
        tableView.reloadData()
    }

    private func deleteSpice(indexPath: IndexPath){


        var temp = taskList[indexPath.row]


        taskList.remove(at: indexPath.row)

        spicesController.deleteSpice(task: temp)

        tableView.deleteRows(at: [indexPath], with: .top)

        tableView.reloadData()
    }

    private func editSpice(indexPath: IndexPath, title: String, subtitle: String){

        var newTemp = Spice(title: title, subtitle: subtitle)
        var temp = Spice(title: taskList[indexPath.row].title, subtitle: taskList[indexPath.row].subtitle )
        taskList[indexPath.row].title = title
        taskList[indexPath.row].subtitle = subtitle
        spicesController.updateSpice(task: temp, newTask: newTemp)
        tableView.reloadData()
    }

    func fetchAllSpice(){
        var allTask = self.spicesController.getAllSpices()
        var needTemp: Bool = false
        if (allTask != nil){
            for task in allTask!{
                needTemp = task.value(forKey: "need")  as! Bool
                self.addSpice(title: task.value(forKey: "title") as! String , subtitle: task.value(forKey: "subtitle") as! String , rNeed: needTemp, insert: false)
            }
        }
    }
}
