//
//  User.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 11.03.2021.
//

import Foundation

public class User {
    public var username : String?
    public var password : String?
    public var mail : String?
        
    
    required init(username : String, password : String, mail : String){
        self.username = username
        self.password = password
        self.mail = mail
    }
}
