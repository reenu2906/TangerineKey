//
//  AuthApi.swift
//  TwistySystems
//
//  Created by Arshad on 06/03/19.
//  Copyright © 2019 Twisty Systems. All rights reserved.
//

import Foundation
import Alamofire

enum AuthApiRequestType: RequestTypeProtocol {
	
	case validateOBD(param: [String:Any])

	func getDataProvider() -> RequestDataProviderProtocol {
		return AuthApiDataProvider()
	}
}

private struct AuthApiDataProvider: RequestDataProviderProtocol {
	
	
	func responseModel(_ type: RequestTypeProtocol,
										 response: [String : Any]) -> (response:APIResponse?, error:Error?)? {
		guard let type = type as? AuthApiRequestType else {
			fatalError("Expected AuthApiRequestType")
		}
		switch type {
      case  .validateOBD(param: _): return AuthModel.parse(JSON: response)
		}
	}
	
	func requestMethodForType(_ type: RequestTypeProtocol) -> HTTPMethod {
		guard let type = type as? AuthApiRequestType else {
			fatalError("Expected AuthApiRequestType")
		}
		switch type {
		case .validateOBD(param: _):
			return .get
		}
	}
	
	func requestUrlForType(_ type: RequestTypeProtocol) -> String {
		guard let type = type as? AuthApiRequestType else {
			fatalError("Expected AuthApiRequestType")
		}
		switch type {
      case .validateOBD(param: _) : return URLConstant.baseURL+APIPaths.validateBooking
		}
	}
	
	func requestParamsForType(_ type: RequestTypeProtocol) -> [String : Any]? {
		guard let type = type as? AuthApiRequestType else {
			fatalError("Expected AuthApiRequestType")
		}
		switch type {
      case .validateOBD(let param):
        return param
    }
	}
  
  
  func requestEncodingForType(_ type: RequestTypeProtocol) -> ParameterEncoding {
    return URLEncoding.default
  }
}
