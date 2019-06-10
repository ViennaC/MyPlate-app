//
//  RecipesViewController.swift
//  Copyright © 2018 CS329E. All rights reserved.
//

import UIKit
import CoreData

var recipes: [NSManagedObject] = []

var titleArray: [String] = []
var imgArray: [String] = []
var sourceURLArray: [String] = []
var selectedRecipeId: String = ""
var selectedRecipeURL: String = ""

class RecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RecipeDataProtocol {
    
    var dataSession = RecipeDataSession()
    
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        self.dataSession.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recipe")
        do {
            recipes = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        var food: String = searchTextField.text!
        food = food.replacingOccurrences(of: " ", with: "+")
        dataSession.getData(food: food)
        titleArray.removeAll()
        imgArray.removeAll()
        sourceURLArray.removeAll()
        self.recipesTableView.reloadData()
    }
    
    func responseDataHandler(data: NSDictionary) {
        let recipeName = data["title"] as! String
        let recipeImage = data["image_url"] as! String
        let sourceURL = data["source_url"] as! String
        
        DispatchQueue.main.async() {
            imgArray.append(recipeImage)
            titleArray.append(recipeName)
            sourceURLArray.append(sourceURL)
            self.recipesTableView.reloadData()
        }
    }
    
    
    func responseError(message: String) {
        DispatchQueue.main.async() {
            titleArray.removeAll()
            imgArray.removeAll()
            self.recipesTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (titleArray.count>=1){
            return titleArray.count
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipeURL = sourceURLArray[indexPath.row]
        popUp(recipe: titleArray[indexPath.row], image: imgArray[indexPath.row], sourceURL: sourceURLArray[indexPath.row])
        print("recipes", recipes)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTitle", for: indexPath) as! RecipesTableViewCell
        if (titleArray.count>=1) {
            cell.RecipeNameLabel?.text = titleArray[indexPath.row]
            let imgURL = URL(string: imgArray[indexPath.row])
            let img = self.extractImg(imgURL: imgURL!)
            cell.RecipeImage?.image = img
        }
        else{
            cell.RecipeNameLabel?.text = ""
            cell.RecipeImage?.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func hideKeyboard(){
        searchTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func saveData(recipe: String, image: String, sourceURL: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: managedContext)!
        let recipeObject = NSManagedObject(entity: entity, insertInto: managedContext)
        recipeObject.setValue(recipe, forKeyPath: "recipe")
        recipeObject.setValue(image, forKeyPath: "image")
        recipeObject.setValue(sourceURL, forKey: "sourceURL")
        do {
            try managedContext.save()
            recipes.append(recipeObject)
            print("inside save data", recipes)
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
    
    func popUp(recipe: String, image: String, sourceURL: String) {
        let alertController = UIAlertController(title: "Recipe Name", message: "What would you like to do with this recipe?", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
            
            self.saveData(recipe: recipe, image: image, sourceURL: sourceURL)
            
        })
        let openAction = UIAlertAction(title: "Open", style: .default, handler: { action in
            let selectedURL = URL(string: selectedRecipeURL)
            UIApplication.shared.open(selectedURL!, options: [:])
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
        alertController.addAction(saveAction)
        alertController.addAction(openAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
