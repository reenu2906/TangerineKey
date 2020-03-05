//
//  RequestTypeProtocol.swift
//  TwistySystems
//
//  Created by Arshad on 06/09/18.
//  Copyright © 2018 Arshad. All rights reserved.
//

import Foundation
import Alamofire

protocol RequestDataProviderProtocol {
	func requestMethodForType(_ type: RequestTypeProtocol) -> HTTPMethod
  func requestHeaderForType(_ type: RequestTypeProtocol) -> HTTPHeaders?
  func requestEncodingForType(_ type: RequestTypeProtocol) -> ParameterEncoding
	func requestUrlForType(_ type: RequestTypeProtocol) -> String
	func requestParamsForType(_ type: RequestTypeProtocol) -> [String: Any]?
	func responseModel(_ type: RequestTypeProtocol,
										 response: [String : Any]) -> (response:APIResponse?, error:Error?)?
}

extension RequestDataProviderProtocol {
	
	func requestHeaderForType(_ type: RequestTypeProtocol) -> HTTPHeaders? {
		let signature = requestSignature
		let header = ["X-Client-Key":APIMetaData.apiClientId,
									"X-UTC-Timestamp":signature.timestamp,
									"Content-Type": "application/x-www-form-urlencoded",
									"X-Request-Signature": signature.signature] as [String : Any]
		
		return header as? HTTPHeaders
	}
}

/// Request Type Protocol
protocol RequestTypeProtocol  {
	
	/// Get the data provider for a request
	///
	/// - Returns: RequestDataProviderProtocol
	func getDataProvider() -> RequestDataProviderProtocol
	
	/// Get request type
	///
	/// - Returns: HTTPMethod
	func getHTTPMethod() -> HTTPMethod
	
  /// Get request parameter Encoding
  ///
  /// - Returns: HTTPMethod
  func getEncoding() -> ParameterEncoding
  
	/// Get request URL
	///
	/// - Returns: URL string
	func getRequestUrl() -> String
	
	/// Get request parameters
	///
	/// - Returns: [String : Any]
	func params() -> [String: Any]?
	
  /// Get request Header
  ///
  /// - Returns: [String : Any]
  func header() -> HTTPHeaders?
  
	/// Response model for the request
	///
	/// - Parameter json: JSON data
	/// - Returns: Model
	func responseModel(_ json: [String : Any]) -> (response:APIResponse?, error:Error?)?
	
}

extension RequestTypeProtocol {
	
	func getHTTPMethod() -> HTTPMethod {
		return getDataProvider().requestMethodForType(self)
	}
	
  func header() -> HTTPHeaders? {
    return getDataProvider().requestHeaderForType(self)
  }
  
	func getRequestUrl() -> String {
		return getDataProvider().requestUrlForType(self)
	}
	
	func params() -> [String: Any]? {
		return getDataProvider().requestParamsForType(self)
	}
	
	func responseModel(_ response: [String : Any]) -> (response:APIResponse?, error:Error?)? {
		return getDataProvider().responseModel(self,
																					 response: response)
	}
	
  func getEncoding() -> ParameterEncoding {
    return getDataProvider().requestEncodingForType(self)
  }
}


