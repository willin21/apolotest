//
//  Constants.swift
//  ApoloTest
//
//  Created by wilnin on 4/07/20.
//  Copyright © 2020 PersonalProject. All rights reserved.
//

import UIKit

struct Constants {
    struct Request {
        static let baseFeedsURL = "https://images-api.nasa.gov/"
        static let searchPath = "search?q=apollo%2011"
    }
    
    struct Text {
        static let titleBar = "Apolo 11"
        static let tryAgain = "Try again"
        static let somethingIsWrong = "Algo salio mal"
        static let delete = "Delete all"
        static let reload = "Reload"
        static let done = "Done"
        static let addfavorites = "You have added this item to favorites succesfully"
        static let removefavorites = "You have removed this item from favorites succesfully"
        static let nonefavoriteItems = "You do not have any favorite items"
        static let noneItems = "You do not have items in list"
        static let errorFavorites = "Somthing is wrong, try again later"
    }
    
    struct Image {
        static let defaultImage = "defaultImage"
        static let favoriteOff = "favoriteOff"
        static let favoriteOn = "favoriteOn"
    }
    
    struct UserDefaults {
        static let saveFavoriteItems = "saveFavoriteItems"
        static let localFavoriteItems = "localFavoriteItems"
    }
}
