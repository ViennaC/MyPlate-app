//
//  ViewController.swift
//  Copyright © 2018 CS329E. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myPlateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, animations: {
            
            self.myPlateLabel.frame.origin.y += 50
            
        }, completion: nil)
        
        UIView.animate(withDuration: 1.5, animations: {
            self.myPlateLabel.alpha = 1.0
        }
        )
        // Do any additional setup after loading the view, typically from a nib.


}

}
