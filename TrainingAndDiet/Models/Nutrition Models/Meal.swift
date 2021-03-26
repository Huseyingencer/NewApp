//
//  Meal.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 22.03.2021.
//

import Foundation
import UIKit

public class Meal : Codable{
    static var class_id : Int = 0
    var meal_id : Int?
    var name : String?
    var energy_rate : Int!
    var protein : Int!
    var fat : Int!
    var serving : Int!
    var serving_portion : Int!
    var repast_name : String?
    var comment : String?
    
    init(name : String, energy_rate : Int, protein : Int, fat : Int, repast_name : String) {
        Meal.class_id += 1
        self.meal_id = Meal.class_id
        self.name = name
        self.energy_rate = energy_rate
        self.protein = protein
        self.fat = fat
        self.repast_name = repast_name
    }
    
    init(name : String, energy_rate : Int, protein : Int, fat : Int, serving : Int,serving_portion : Int, repast_name : String,comment : String?) {
        self.name = name
        self.energy_rate = energy_rate
        self.protein = protein
        self.fat = fat
        self.serving = serving
        self.serving_portion = serving_portion
        self.repast_name = repast_name
        if(comment != nil){
            self.comment = comment
        }
        else {
            self.comment = ""
        }
    }
   
    
    
    
}
