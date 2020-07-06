//
//  UserDefaultsHelper.swift
//  ApoloTest
//
//  Created by wilnin on 5/07/20.
//  Copyright © 2020 PersonalProject. All rights reserved.
//

import UIKit

class UserDefaultsHelper{
    static func saveObject(objectToSave: Any, forKey key: String) {
        let defaults = UserDefaults.standard
        defaults.set(objectToSave, forKey: key)
    }
 
    static func getObject(forKey key: String) -> Any? {
        let defaults = UserDefaults.standard
        let savedObject = defaults.object(forKey: key)
        return savedObject
    }
    
    static func removeObject(forKey key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
}
