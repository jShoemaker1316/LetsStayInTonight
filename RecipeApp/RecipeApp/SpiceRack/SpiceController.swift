//
//  SpiceController.swift
//  RecipeApp
//
//  Created by Jonathan Shoemaker on 9/18/20.
//  Copyright © 2020 JonathanShoemaker. All rights reserved.
//

import Foundation
import UIKit
import CoreData


public class SpiceController{

    func insertSpice(newTask: Spice){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let taskEntity : NSEntityDescription? = NSEntityDescription.entity(forEntityName: "SpiceEntity", in: managedContext)


        if (taskEntity != nil){
            let task = NSManagedObject(entity: taskEntity!, insertInto: managedContext)

            task.setValue(newTask.title, forKey: "title")
            task.setValue(newTask.subtitle, forKey: "subtitle")
            task.setValue(false, forKey: "need")


            do{
                //to perform insert operation on database table
                try managedContext.save()

            }catch let error as NSError{
                print("Insert task failed...\(error), \(error.userInfo)")
            }
        }
    }

    func updateSpice(task : Spice, newTask: Spice){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SpiceEntity")

        fetchRequest.predicate = NSPredicate(format: "title = %@", task.title)

        do{
            let result = try managedContext.fetch(fetchRequest)

            let existingTask = result[0] as! NSManagedObject

            existingTask.setValue(newTask.title, forKey: "title")
            existingTask.setValue(newTask.subtitle, forKey: "subtitle")

            do{
                try managedContext.save()
                print("Spice update Successful")
            }catch{
                print("Spice update unsuccessful")
            }
        }catch{
            print("Spice update unsuccessful")
        }

    }

    func updateSpiceGotIt(task : Spice){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SpiceEntity")

        fetchRequest.predicate = NSPredicate(format: "title = %@", task.title)

        do{
            let result = try managedContext.fetch(fetchRequest)

            let existingTask = result[0] as! NSManagedObject

            existingTask.setValue(task.need, forKey: "need")

            do{
                try managedContext.save()
                print("Spice update Successful")
            }catch{
                print("Spice update unsuccessful")
            }
        }catch{
            print("Spice update unsuccessful")
        }

    }

    func deleteSpice(task: Spice){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SpiceEntity")

        fetchRequest.predicate = NSPredicate(format: "title = %@", task.title)

        do{
            let result = try managedContext.fetch(fetchRequest)
            let existingTask = result[0] as! NSManagedObject

            managedContext.delete(existingTask)

            do{
                try managedContext.save()
                print("Task delete Successful")
            }catch{
                print("Task delete unsuccessful")
            }

        }catch{

        }


    }



    func getAllSpices() -> [NSManagedObject]?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SpiceEntity")

        do{
            let result = try managedContext.fetch(fetchRequest)
            return result as? [NSManagedObject]
        }catch{
            print("Data fetching Unsuccessful")
        }
        return nil
    }
}
