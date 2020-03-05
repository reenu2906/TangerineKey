//
//  TwistySystemsAPIManager.swift
//  TwistySystems
//
//  Created by Arshad on 24/10/18.
//  Copyright © 2018 Arshad. All rights reserved.
//
import Foundation
import Alamofire

class APIManager {
	
	private static var alamofireManager = Alamofire.SessionManager.default
	
	/// Create a webservice request for given type.
	///
	/// - Parameters:
	///   - type: request type as RequestTypeProtocol
	///   - completion: response as Response model
	func request(type: RequestTypeProtocol,
							 completion: @escaping (_ response:APIResponse?, _ error:Error?) -> Void ) {
		if NetworkReachabilityManager()!.isReachable {
			let method = type.getHTTPMethod()
			let requestURL = URL(string: type.getRequestUrl())!
			debugPrint(requestURL)
			let parameters = type.params()
			debugPrint(parameters ?? "Empty Parameter")
      let header = type.header()
			debugPrint(header ?? "Empty Header")
      let encoding = type.getEncoding()
			debugPrint(encoding )

			let request = APIManager.alamofireManager.request(requestURL,
																																	 method: method,
																																	 parameters: parameters,
																																	 encoding: encoding,
																																	 headers: header)
			APIManager.alamofireManager.session.configuration.timeoutIntervalForRequest = 10
			request.responseData(completionHandler: { response in
				
				
				self.validateResponse(response,
															type: type,
															completion)
			})
		} else {
			completion(nil, APIError.noNetworkConnection(message: "No Network"))
		}
	}
	
	/// Validate the webservice response and generate a Response model obeject.
	///
	/// - Parameters:
	///   - response: DataResponse
	///   - type: request type conforming RequestTypeProtocol
	///   - callback: Response model object with success/error details
	func validateResponse(_ response: DataResponse<Data>,
												type: RequestTypeProtocol,
												_ callback: @escaping (_ response:APIResponse?, _ error:Error?) -> Void) {
		switch response.result {
		case .success(let data):
			do {
				if let responseJSON =  try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
					if let error = APIError.init(serverResponse: responseJSON) {
						callback(nil, error)
					} else {
						let model = type.responseModel(responseJSON)
						callback(model?.response, model?.error)
					}
				}
			}
			catch {
				callback(nil, APIError.dataFormatError(message: error.localizedDescription))
			}
		case .failure(let error):
			callback(nil, error)
		}
	}
	
	/// Cancell all webservice requests
	public class func cancelAllRequests() {
		APIManager.alamofireManager.session.getAllTasks { (dataTask) in
			dataTask.forEach { $0.cancel() }
		}
	}
}
