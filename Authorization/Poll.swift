//
//  Poll.swift
//  Authorization
//
//  Created by Akerke Okapova on 7/4/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireImage

struct Poll: Mappable {

    var imageUrl = ""
    var title = ""
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        imageUrl <- map["image"]
        title <- map["title"]
    }
    
    static func getPolls(completion: @escaping ([Poll]?, String?) -> Void) {
        
        let url = "https://apivotem.solf.io/api/polls/feed/"
        
        Alamofire.request(url, method: .post).responseJSON { response in
            switch response.result{
            case .failure(let error):
                completion(nil, error.localizedDescription)
            case .success(let value):
                let json = value as! [String: Any]
                
                let code = json["code"] as! Int
                switch code {
                case 0:
                    let results = json["result"] as! [[String: Any]]
                    completion(results.map { Poll(JSON: $0)! }, nil)
                default:
                    completion(nil, "Unknown error")
                }
            }
        }
    }
}
