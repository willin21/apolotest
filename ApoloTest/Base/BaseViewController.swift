//
//  BaseViewController.swift
//  ApoloTest
//
//  Created by wilnin on 5/07/20.
//  Copyright © 2020 PersonalProject. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func savedFavorite(object: Items) {
        var localFavorites = [Items]()
        var isExistent: Bool = false
        let id = object.data![0].nasa_id
        
        if let myCurrentFavorites = getFavorites() {
            localFavorites = myCurrentFavorites
            isExistent = doesThisFavoriteExists(array: localFavorites, id: id!)
            
            if isExistent {
                let filteredIndices = localFavorites.indices.filter { localFavorites[$0].data![0].nasa_id == id }
                
                var index: Int = 0
                _ = filteredIndices.map {index = $0}
                localFavorites.remove(at: index)
                alertFavorite(textAlert: Constants.Text.removefavorites)
            }
        }
        
        if !isExistent {
            localFavorites.append(object)
            alertFavorite(textAlert: Constants.Text.addfavorites)
        }
        
        let encodedPreferences = try! JSONEncoder().encode(localFavorites)
        UserDefaultsHelper.saveObject(objectToSave: encodedPreferences, forKey: Constants.UserDefaults.saveFavoriteItems)
    }
    
    func getFavorites() -> [Items]? {
        if let encodeData = UserDefaultsHelper.getObject(forKey: Constants.UserDefaults.saveFavoriteItems) as? Data {
            if let favorites = try? JSONDecoder().decode([Items].self, from: encodeData), favorites.count > 0 {
                return favorites
            }
        }
        
        return nil
    }
    
    func removeAllFavorites() {
        UserDefaultsHelper.removeObject(forKey: Constants.UserDefaults.saveFavoriteItems)
    }
    
    func doesThisFavoriteExists(array: [Items], id: String) -> Bool {
        for item in array {
            if item.data![0].nasa_id == id {
                return true
            }
        }
        
        return false
    }
    
    func alertFavorite(textAlert: String) {
        let alert = UIAlertController(title: "", message: textAlert, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Constants.Text.done, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
