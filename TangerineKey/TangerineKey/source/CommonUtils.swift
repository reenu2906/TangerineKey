//
//  CommonUtils.swift
//  JIDO KEY
//
//  Created by Arshad on 03/04/19.
//

import UIKit
import CommonCrypto

class CommonUtilities: NSObject {
	
	// ---------------
	// MARK: - General
	// ---------------
	
	/// Return the top view controller to the given view controller or to the root window if no view controller given.
	///
	/// - Returns: Top most UIViewController object in the view presenting stack.
	class func getTopViewController(of viewController: UIViewController? = nil) -> UIViewController? {
		if var topController = viewController ?? UIApplication.shared.keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			// TopController should now be your topmost view controller
			return topController
		}
		return nil
	}
	
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
