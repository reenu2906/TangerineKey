//
//  Date+Extension.swift
//  TangerineKey
//
//  Created by Reenu Deswal on 06/03/20.
//  Copyright © 2020 Reenu Deswal . All rights reserved.
//


import Foundation
public extension Date {
	
	static func date(from dateString: String, with format: String) -> Date? {
		let dateFormatter        = DateFormatter()
		dateFormatter.dateFormat = format // Your date format
		dateFormatter.locale     = Locale(identifier: "en_US")
		dateFormatter.timeZone   = TimeZone(abbreviation: "GMT+0:00") // Current time zone
		let date                 = dateFormatter.date(from: dateString) // According to date format your date string
		return date
	}
}
