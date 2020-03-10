//
//  Double+Extensions.swift
//  JIDO KEY
//
//  Created by Arshad on 09/05/19.
//

import Foundation

public extension Double {
	
	/// Method conver Double to String with no decimal digits
	public var cleanStringValue: String {
		return String(format: "%.0f", self)
	}
}
