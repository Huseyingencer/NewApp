//
//  User.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 11.03.2021.
//

import Foundation

public class User : NSObject, NSCoding
{
    public func encode(with coder: NSCoder) {
        coder.encode(self.username, forKey: "username")
        coder.encode(self.password, forKey: "password")
        coder.encode(self.mail,forKey: "mail")
    }
    
    public required init?(coder decoder: NSCoder) {
        if let username = decoder.decodeObject(forKey: "username") as? String{
            self.username = username
            if let password = decoder.decodeObject(forKey: "password") as? String{
                self.password = password
                if let mail = decoder.decodeObject(forKey: "mail") as? String{
                    self.mail = mail
                }
            }
        }
        
    }
    
   
    
    public var username : String?
    public var password : String?
    public var mail : String?
        
    
    required init(username : String, password : String, mail : String){
        self.username = username
        self.password = password
        self.mail = mail    
    }
}
