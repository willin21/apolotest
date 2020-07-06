//
//  NetworkingDataManager.swift
//  ApoloTest
//
//  Created by wilnin on 4/07/20.
//  Copyright © 2020 PersonalProject. All rights reserved.
//

import UIKit
import Alamofire

class NetworkingDataManager {
    func callService<T: Decodable>(_ url : URLRequest, success: @escaping (_ response: T) -> Void, errorMessage: @escaping (String) -> Void) {
        Alamofire.request(url).responseJSON{ (response) -> Void in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(T.self, from: data)
                        success(model)
                    } catch let error as NSError {
                        print(error)
                    }
                }
            case .failure(let error):
                let message: String
                if let httpStatusCode = response.response?.statusCode {
                    message = "Error: \(httpStatusCode)"
                } else {
                    message = error.localizedDescription
                }
                
                errorMessage(message)
            }
        }
    }
}
