//
//  User.swift
//  Authorization
//
//  Created by Akerke Okapova on 6/22/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import Foundation
import Alamofire

struct User {
    
    var token = ""
    var id = 0
    var email = ""
    
    init(from json: [String: Any]) {
        token = json["token"] as! String
        
        let user = json["user"] as! [String: Any]
        id = user["id"] as! Int
        email = user["username"] as! String
    }
    
    static func emailIsValid(email: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    static func passwordIsValid(password: String) -> Bool {
        
        return password.characters.count > 3
    }
    
    static func authorize(email: String,
                          password: String,
                          completion: @escaping (User?, String?) -> Void){
        
        let parameters = [
            "username": email,
            "password": password
        ]
        
        let url = "https://apivotem.solf.io/api/authe/login/"
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result{
            case .failure(let error):
                completion(nil, error.localizedDescription)
            case .success(let value):
                let json = value as! [String: Any]
                
                let code = json["code"] as! Int
                switch code {
                case 0:
                    //defaults.set(json, forKey: UIViewController.userInfoKey)
                    saveToStorage(json: json)
                    completion(User(from: json), nil)
                case 6:
                    completion(nil, "Такого email не существует")
                default:
                    completion(nil, "Неизвестная ошибка, попробуйте снова")
                }
            }
        }
    }
    static func saveToStorage(json: [String: Any]) {
        defaults.set(json, forKey: UIViewController.userInfoKey)
    }
    
    static func deleteFromStorage(){
        
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaults.synchronize()
    }
}
