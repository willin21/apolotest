//
//  ApoloListViewModel.swift
//  ApoloTest
//
//  Created by wilnin on 4/07/20.
//  Copyright © 2020 PersonalProject. All rights reserved.
//

import Alamofire

class ApoloListViewModel {
    var resultsViewModelList: MetaDataModel?
    
    func loadResults(success: @escaping () -> Void, errorMessage: @escaping (String) -> Void) {
        let url = URL(string: "\(Constants.Request.baseFeedsURL)\(Constants.Request.searchPath)")!
        let request = URLRequest(url: url)

        NetworkingDataManager().callService(request, success: { (response: MetaDataModel) in
            self.resultsViewModelList = response
            success()
        }, errorMessage: { (error) in
            print("errorjt", error)
            errorMessage(error)
        })
    }
}
