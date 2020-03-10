//
//  AuthModel.swift
//  TangerineKey
//
//  Created by Reenu Deswal on 06/03/20.
//  Copyright © 2020 Reenu Deswal . All rights reserved.
//


import Foundation

public struct AuthModel: Codable {
	
	public var endTimeString: String
	public var startTimeString: String
	public var veicleNumber: String
    public var obdId : String
	
	enum CodingKeys: String,CodingKey
	{
		case endTimeString = "end_time"
		case startTimeString = "start_time"
		case veicleNumber = "vehicle_number"
		case obdId        = "obdId"
	}
	public var isSessionExpired: Bool {
		let startDate = Date.date(from: startTimeString, with: "yyyy-MM-dd HH:mm:ss")
		let endDate 	= Date.date(from: endTimeString, with: "yyyy-MM-dd HH:mm:ss")
		if let startTimeStamp = startDate?.timeIntervalSince1970, let endTimeStamp = endDate?.timeIntervalSince1970 {
			let currentTimeStamp = Date().timeIntervalSince1970
			if currentTimeStamp > startTimeStamp && currentTimeStamp < endTimeStamp {
				return false
			}
		}
		return true
	}
	
	public var hasValidData: Bool {
		return !endTimeString.isEmpty && !startTimeString.isEmpty && !veicleNumber.isEmpty && endTimeString.count > 0 && startTimeString.count > 0 && veicleNumber.count > 0
	}
}

extension AuthModel: APIResponse {
    public static func parse(JSON: [String: Any]) -> (response:APIResponse?, error:Error?) {
		do {
			guard let data = JSON[APIKeys.data] as? [String: Any] else {
				return (nil, APIError.noData(message: "No data found"))
			}
			let theJSONData = try JSONSerialization.data(withJSONObject: data, options: [])
			let result = try JSONDecoder().decode(AuthModel.self, from: theJSONData)
			return (result, nil)
		}
		catch {
			return (nil, error)
		}
	}
}
