//
//  APIManager+User.swift
//  TangerineKey
//
//  Created by Reenu Deswal on 06/03/20.
//  Copyright © 2020 MAC PRO. All rights reserved.
//

import Foundation
import Alamofire

public extension APIManager {
    
    func validateSlot(phoneNumber : String, refNumber : String, completion: @escaping (AuthModel?, Error?)->()){
        let param = [APIKeys.phoneNumber:phoneNumber,
                     APIKeys.bookingReference: refNumber]
        let request = AuthApiRequestType.validateOBD(param: param)
        self.request(type: request) {(response, error) in
            if let error = error {
                completion(nil, APIError.serverError(message: error.localizedDescription))
            } else if  let loginResponse = response as? AuthModel {
                let endDate = Date.date(from: loginResponse.endTimeString, with: "yyyy-MM-dd HH:mm:ss")
                if let endTimeStamp = endDate?.timeIntervalSince1970 {
                    DataManager.shared.bookingEndtime = endTimeStamp
                    let currentTimeStamp = Date().timeIntervalSince1970
                    if currentTimeStamp > endTimeStamp {
                        completion(nil, APIError.slotExpired(message: "booking slot has expired"))
                    }else {
                        completion(loginResponse, nil)
                    }
                }
            } else {
                completion(nil, APIError.noData(message: "No data found"))
            }
        }
    }
}
