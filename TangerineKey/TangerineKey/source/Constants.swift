//
//  Constants.swift
//  TangerineKey
//
//  Created by Reenu Deswal on 06/03/20.
//  Copyright © 2020 Reenu Deswal . All rights reserved.
//

import Foundation


public struct BLEMessageContent {
	static let payload 		= "JidoKey"
	static let separator 	= ","
	static let bookID			= "#bi"
	static let command		= "#c"
	static let eom				= "#e"
    static let obdID        = "#ob"
}

public enum BLEResponse: String {
	case success = "#y"
	case failure = "#n"
	case notConnected = "#nc"
	case parseError = "#pe"
    case connectionDenied = "#ac"
    case senseInternetIssue = "#nn"
}

