//
//  AuthApi.swift
//  TangerineKey
//
//  Created by Reenu Deswal on 06/03/20.
//  Copyright © 2020 Reenu Deswal . All rights reserved.
//


import Foundation
import Alamofire

public enum AuthApiRequestType: RequestTypeProtocol {
	
	case validateOBD(param: [String:Any])

    public func getDataProvider() -> RequestDataProviderProtocol {
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
