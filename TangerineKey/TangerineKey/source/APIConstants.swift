//
//  APIConstants.swift
//  TangerineKey
//
//  Created by Reenu Deswal on 06/03/20.
//  Copyright © 2020 Reenu Deswal . All rights reserved.
//


import Foundation

public struct URLConstant {
    static let baseURL = "https://api.tangerine.ai/v1/"
}

struct APIMetaData {
	
	static let apiClientId  = "Generic Client"
	static let apiSecretKey = "DVOOtItNDnkwugzgyVDmEUpllHjTgPrORQhq"
}

struct APIPaths {
	
	// MARK: - Auth
	static let validateBooking = "booking/validate"
}


struct APIErrorDescription {
  static let cancelled = "cancelled"
}

public struct APIKeys {
	//Base keys

  static let code = "code"
  static let message = "message"
  static let data = "data"
	
	//Auth keys
	public static let bookingReference = "booking_reference"
	public static let phoneNumber = "phone_number"

}

typealias APICallBack =  (_ response:APIResponse?, _ error:Error?) -> Void

/// Prepares and return the API request signature.
///
/// - Returns: Touple representing the signature created timestamp and signature, both in string format
var requestSignature: (timestamp:String, signature:String) {
	let timeStampUTC     = String(Date().timeIntervalSince1970)
	let md5Data          = CommonUtilities.MD5(string: APIMetaData.apiClientId + timeStampUTC + APIMetaData.apiSecretKey)
	let requestSignature = md5Data!.map { String(format: "%02hhx", $0) }.joined()
	return (timeStampUTC, requestSignature)
}

