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
                    defaults.set(json, forKey: "userTokenInfo")
                    completion(User(from: json), nil)
                case 6:
                    completion(nil, "Такого email не существует")
                default:
                    print("Пришел код ошибки, который мы не обрабатываем")
                }
            }
        }
    }
}
