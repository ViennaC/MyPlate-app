//
//  savedRecipesTableViewController.swift
//  Copyright © 2018 CS329E. All rights reserved.
//

import UIKit
import CoreData

class savedRecipesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateSavedRecipes()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as! savedRecipesTableViewCell
        updateSavedRecipes()
        let recipeCurrent = recipes[indexPath.row]
        let recipeName = recipeCurrent.value(forKey: "recipe") as? String
        let imgString = recipeCurrent.value(forKey: "image") as? String
        let imgURL = URL(string: imgString!)
        let img = self.extractImg(imgURL: imgURL!)
        let sourceURL = recipeCurrent.value(forKey: "sourceURL") as? String
        cell.savedRecipeNameLabel.text = recipeName
        cell.savedRecipeImage.image = img
        self.tableView.rowHeight = 150.0
        return cell
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeCurrent = recipes[indexPath.row]
        let source = recipeCurrent.value(forKey: "sourceURL") as? String
        let sourceURL = URL(string: source!)
        UIApplication.shared.open(sourceURL!, options: [:])
        print("recipes", recipes)
    }
    
    //UITableViewDelegate for swipe actions
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.deleteRecipe(indexPath: editActionsForRowAt)
        }
        delete.backgroundColor = .red
        return [delete]
    }
    
    func deleteRecipe(indexPath: IndexPath){
        
        print ("Deleting: ", indexPath.row)
        
        //first, remove from CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        
        let result = try? managedContext.fetch(fetchRequest) as! [NSManagedObject]
        
        
        for object in result! {
            
            let delRecipe = object.value(forKey: "recipe") as? String
            let delImage = object.value(forKey: "image") as? String
            let delSource = object.value(forKey: "sourceURL") as? String
            let recipeCurrent = recipes[indexPath.row]
            let recipeName = recipeCurrent.value(forKey: "recipe") as? String
            let imgString = recipeCurrent.value(forKey: "image") as? String
            let sourceURL = recipeCurrent.value(forKey: "sourceURL") as? String
            if ((delRecipe == recipeName) && (delImage == imgString) && (delSource == sourceURL))
            {
                print ("Deleted: ", indexPath.row)
                managedContext.delete(object)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
        //then, remove from our adventurers list
        let index = (indexPath.row)
        recipes.remove(at: index)
        
        //finally, remove from the table view
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    
    func updateSavedRecipes(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recipe")
        
        do{
            recipes = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func extractImg(imgURL: URL) -> UIImage {
        guard let imgData = try? Data(contentsOf: imgURL)
            else{
                return UIImage(named: "noimg")!
        }
        let img = UIImage(data: imgData)
        return img!
    }

}
