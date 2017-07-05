//
//  User.swift
//  Authorization
//
//  Created by Akerke Okapova on 6/22/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireImage

struct User: Mappable {
    
    var token = ""
    var id = 0
    var email = ""
    var name = ""
    var imageUrl = ""
    var telephone = ""
    var city = ""
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        token <- map["token"]
        id <- map["user.id"]
        email <- map["user.email"]
        name <- map["user.full_name"]
        imageUrl <- map["user.avatar"]
        telephone <- map["user.phone"]
        city <- map["user.city"]
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
                print(value)
                let json = value as! [String: Any]
                
                let code = json["code"] as! Int
                switch code {
                case 0:
                    let user = User(JSON: json)!
                    completion(user, nil)
                case 6:
                    completion(nil, "Такого email не существует")
                default:
                    completion(nil, "Попробуйте снова")
                }
            }
        }
    }
    
    static func fetchImage(with url: String,
                           completion: @escaping (UIImage?) -> Void) {
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                Storage.addImage(image: image, url: url)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
}
