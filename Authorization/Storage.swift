//
//  Storage.swift
//  Authorization
//
//  Created by Akerke Okapova on 6/27/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import Cache

private struct Caches {
    static let jsonCache = SpecializedCache<JSON>(name: "JSON Cache")
    static let imageCache = SpecializedCache<UIImage>(name: "Image Cache")
}

private struct Keys {
    static let user = "User"
}

struct Storage {
    
    static var user: User? {
        get {
            if let json = Caches.jsonCache.object(forKey: Keys.user) {
                switch json {
                case .dictionary(let userJSON):
                    return User(JSON: userJSON)!
                default:
                    break
                }
            }
            return nil
        }
        set {
            if let user = newValue {
                //print(user)
                try! Caches.jsonCache.addObject(JSON.dictionary(user.toJSON()), forKey: Keys.user)
            } else {
                try! Caches.jsonCache.removeObject(forKey: Keys.user)
            }
        }
    }
    
    static func addImage(image: UIImage, url: String) {
        print("ADD TO CACHE: \(url)")
        Caches.imageCache.async.addObject(image, forKey: url) { error in
            print(error ?? "add ok")
        }
    }
    
    static func removeImage(url: String) {
        Caches.imageCache.async.removeObject(forKey: url) { error in
            print(error ?? "remove ok")
        }
    }
    
    static func getImage(url: String, completion: @escaping (UIImage?) -> Void) {
        Caches.imageCache.async.object(forKey: url, completion: completion)
    }
}
