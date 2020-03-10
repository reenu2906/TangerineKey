//
//  ResponseModel.swift
//  TangerineKey
//
//  Created by Reenu Deswal on 06/03/20.
//  Copyright © 2020 Reenu Deswal . All rights reserved.
//

public enum APIError:Error  {
	case noNetworkConnection(message: String)
	case dataFormatError(message: String)
	case noData(message: String)
	case serverError(message: String)
    case slotExpired(message : String)

	init?(serverResponse response: Dictionary<String,Any>) {
		
		if response.keys.contains(APIKeys.code), response.keys.contains(APIKeys.message) {
			if let responseCode = response[APIKeys.code] as? Int, responseCode < 0 {
                if responseCode == -1503 {
                    let message = "Booking session has ended"
                    self = .serverError(message: message)
                } else {
                    let message = (response[APIKeys.message] as? String) ?? "Something went wrong please try again later."
                    self = .serverError(message: message)
                }
				return
			}
		} else {
			self = .dataFormatError(message: "Data format error")
			return
		}
		return nil
	}
}


public protocol  APIResponse {
	
	static func parse(JSON: [String: Any]) -> (response:APIResponse?, error:Error?)
}

extension APIResponse {
    public static func parse(JSON: [String: Any]) -> (response:APIResponse?, error:Error?) {
		return (JSON,nil)
	}
}

extension Array: APIResponse {
	
}

extension Dictionary: APIResponse {
	
}


