//
//  NutritionData.swift
//  Copyright © 2018 CS329E. All rights reserved.
//

import Foundation
import UIKit

protocol RecipeDataProtocol{
    func responseDataHandler(data: NSDictionary)
    func responseError(message: String)
}

class RecipeDataSession{
    private let urlSession = URLSession.shared
    private let urlPathBase = "https://www.food2fork.com/api/search?key=83bad68c4df910a76f4bc4c18289eb71"
    
    private var dataTask: URLSessionDataTask? = nil
    
    var delegate:RecipeDataProtocol? = nil
    
    init() {}
    
    func getData(food: String){
        var urlPath = self.urlPathBase
        urlPath = urlPath + "&q=" + food
        let url: NSURL? = NSURL(string: urlPath)
        if (url != nil) {
            let dataTask = self.urlSession.dataTask(with: url! as URL) { (data, response, error) -> Void in
                if error != nil {
                    print(error)
                }
                else{
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        if jsonResult != nil {
                            print(url)
                            let recipesArray = jsonResult!["recipes"] as? [NSDictionary]
                            if recipesArray != nil{
                                var count: Int = 0
                                while (count<recipesArray!.count && count<=9){
                                    self.delegate?.responseDataHandler(data: recipesArray![count])
                                    count = count + 1
                                }
                            } else{
                                self.delegate?.responseError(message: "Data not found")
                            }
                        }else{
                            self.delegate?.responseError(message: "Data not found")
                        }
                    }
                    catch{
                        self.delegate?.responseError(message: "Data not found.")
                    }
                }
            }
            dataTask.resume()
        }
            
        else {
            self.delegate?.responseError(message: "Data not found")
        }
    }
    
}

