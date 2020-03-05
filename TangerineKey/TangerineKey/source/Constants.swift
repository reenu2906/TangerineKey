//
//  Constants.swift
//  JIDO KEY
//
//  Created by Arshad on 28/03/19.
//

import Foundation

struct SegueID {
	static let showHomeSegue = "showHomeSegue"
	static let getStartedSegue = "getStartedSegue"
	static let showHomeFromSplashSegue = "showHomeFromSplashSegue"
}

struct BLEMessageContent {
	static let payload 		= "JidoKey"
	static let separator 	= ","
	static let bookID			= "#bi"
	static let command		= "#c"
	static let eom				= "#e"
    static let obdID        = "#ob"
}
enum BLEResponse: String {
	case success = "#y"
	case failure = "#n"
	case notConnected = "#nc"
	case parseError = "#pe"
    case connectionDenied = "#ac"
    case senseInternetIssue = "#nn"
}

enum AppState {
	case notInitialized
	case initializing
	case initialized
}
