//
//  BuildingRecipesViewController.swift
//  Copyright © 2018 CS329E. All rights reserved.
//

import UIKit

var calorieCount = 0
var selectedCalorieRow = 0

class BuildingRecipesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let items = ["Beans", "Beef", "Broccoli", "Chicken Breast", "Eggs", "Fish", "Onions", "Potatoes", "Rice", "Spaghetti", "Tomatoes"]
    let calories = [42, 213, 110, 206, 211, 211, 46, 116, 270, 221, 32]
 
    
    @IBOutlet weak var bowlImageView: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var ingredientPickerView: UIPickerView!
    @IBOutlet weak var calorieCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientPickerView.delegate = self
        ingredientPickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (items[row] + ": +" + String(calories[row]) + " cal")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCalorieRow = row
    }
    
    func popUp() {
        let alertController = UIAlertController(title: "Add Ingredient", message: "What ingredient would you like to add?", preferredStyle: .alert)
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Enter item name."
        }

        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Enter amount of calories."
        }

        let addAction = UIAlertAction(title: "Add Ingredient", style: .default, handler: { action in
            let calorieTextField = alertController.textFields![1] as UITextField
            calorieCount += Int(calorieTextField.text!)!
            let itemTextField = alertController.textFields![0] as UITextField
            self.calorieCountLabel.text = "\(calorieCount) calories"
            
            self.ingredientsTextView.insertText(itemTextField.text! + " added +" + calorieTextField.text! + " calories. \n")
            
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }


    
    @IBAction func addItemButton(_ sender: UIButton) {
        calorieCount += calories[selectedCalorieRow]
        calorieCountLabel.text = "\(calorieCount) calories"
        var imageView: UIImageView
        imageView = UIImageView(frame: CGRect(x:(self.view.frame.width)/2-120, y:0, width:240, height:128))
        imageView.image = UIImage(named: items[selectedCalorieRow]+".png")
        self.view.addSubview(imageView)
        UIImageView.animate(withDuration: 1) {
            imageView.frame.origin.y += self.bowlImageView.frame.origin.y - 20
            imageView.frame.origin.x += 25
        }
        
        ingredientsTextView.insertText(items[selectedCalorieRow] + " added +" + String(calories[selectedCalorieRow]) + " calories. \n")
    }
    
    @IBAction func createItemButton(_ sender: UIButton) {
        popUp()
    }
    
}
