//
//  BMITableViewController.swift
//  Copyright © 2018 CS329E. All rights reserved.
//

import UIKit
import CoreData

var bmiDataList: [NSManagedObject] = []

class BMITableViewController: UITableViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBMIs()
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
        return bmiDataList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "yourMom", for: indexPath) as! BMITableViewCell
        
        //update
        updateBMIs()
        
        let bmiCurrent = bmiDataList[indexPath.row]
        
        let time = bmiCurrent.value(forKeyPath: "time") as? String
        let bmi = bmiCurrent.value(forKeyPath: "bmiStr") as? String
        
        cell.timeLabel.text = bmiCurrent.value(forKeyPath: "time") as? String
        cell.bmiLabel.text = bmiCurrent.value(forKeyPath: "bmiStr") as? String
        self.tableView.rowHeight = 100.0
        
        
        return cell
    }
    
    //UITableViewDelegate for swipe actions
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.deleteBMI(indexPath: editActionsForRowAt)
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    func deleteBMI(indexPath: IndexPath){
        
        print ("Deleting: ", indexPath.row)
        
        //first, remove from CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BMIData")
        
        let result = try? managedContext.fetch(fetchRequest) as! [NSManagedObject]
        
        
        for object in result! {
            
            let delBMI = object.value(forKey: "bmiStr") as? String
            let delTime = object.value(forKey: "time") as? String
            
            let time = bmiDataList[indexPath.row].value(forKey: "time") as? String
            let bmi = bmiDataList[indexPath.row].value(forKey: "bmiStr") as? String
            if ((delBMI == bmi) && (delTime == time))
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
        bmiDataList.remove(at: index)
        
        //finally, remove from the table view
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    func updateBMIs()
    {
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "BMIData")
        
        //3
        do {
            bmiDataList = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
