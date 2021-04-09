//
//  JsonStructs.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 1.04.2021.
//

import Foundation

struct Entry : Codable{
    var Succes : Bool
    var ErrorMessage : String
    var Result : [CustomItem]
}

struct CustomItem : Codable{
    var title : String
    var image : String
    var content : String
}
