//
//  CommonUtils.swift
//  TangerineKey
//
//  Created by Reenu Deswal on 06/03/20.
//  Copyright © 2020 Reenu Deswal . All rights reserved.
//

import UIKit
import CommonCrypto

class CommonUtilities: NSObject {
	
	
	/// Prepares the MD5 for the given input string.
	///
	/// - Parameter string: String for which MD5 need to be created
	/// - Returns: The MD5 of the input.
	static func MD5(string: String) -> Data? {
		guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
		var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
		
		_ = digestData.withUnsafeMutableBytes {digestBytes in
			messageData.withUnsafeBytes {messageBytes in
				CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
			}
		}
		
		return digestData
	}
}
