//
//  DESEncryptor.swift
//  TangerineKey
//
//  Created by Reenu Deswal on 06/03/20.
//  Copyright © 2020 Reenu Deswal . All rights reserved.
//

import Foundation
import CommonCrypto

public struct DESEncryptor {
	
	private static let key:NSString = "sup3rS3xy"
	
	static func doCipher(encryptValue: NSString) -> String? {
		
		let vplainText = encryptValue.utf8String
		let plainTextBufferSize: size_t = encryptValue.length
		var ccStatus: CCCryptorStatus
		
		let buffer_size : size_t = (plainTextBufferSize+kCCBlockSize3DES) & ~(kCCBlockSizeDES - 1)
		let buffer = UnsafeMutablePointer<NSData>.allocate(capacity: buffer_size)
		
		let vkey = key.utf8String
		
		var movedBytes: size_t = 0
		
		ccStatus = CCCrypt(CCOperation(kCCEncrypt),
											 CCAlgorithm(kCCAlgorithmDES),
											 CCOptions(kCCOptionPKCS7Padding + kCCOptionECBMode),
											 vkey,
											 kCCKeySizeDES,
											 nil,
											 vplainText,
											 plainTextBufferSize,
											 buffer,
											 buffer_size,
											 &movedBytes)
		
		
		if ccStatus >= 0,  UInt32(ccStatus) == UInt32(kCCSuccess) {
			let myResult : NSData = NSData(bytes: buffer, length: movedBytes)
			let encryptedStr = myResult.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
			return encryptedStr
		}
		return nil
	}
	
	static func doDecipher(encryptedValue: String) -> NSString? {
		
		guard let vplainText = NSData.init(base64Encoded: encryptedValue, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) else {
			return nil
		}
		let plainTextBufferSize: size_t = vplainText.length
		var ccStatus: CCCryptorStatus
		
		let buffer_size : size_t = (plainTextBufferSize+kCCBlockSize3DES) & ~(kCCBlockSizeDES - 1)
		let buffer = UnsafeMutablePointer<NSData>.allocate(capacity: buffer_size)
		
		let vkey = key.utf8String
		
		var movedBytes: size_t = 0
		
		ccStatus = CCCrypt(CCOperation(kCCDecrypt),
											 CCAlgorithm(kCCAlgorithmDES),
											 CCOptions(kCCOptionPKCS7Padding + kCCOptionECBMode),
											 vkey,
											 kCCKeySizeDES,
											 nil,
											 vplainText.bytes,
											 plainTextBufferSize,
											 buffer,
											 buffer_size,
											 &movedBytes)
		if ccStatus >= 0,  UInt32(ccStatus) == UInt32(kCCSuccess) {
			let myResult : NSData = NSData(bytes: buffer, length: movedBytes)
			let decryptedStr = NSString(data: myResult as Data, encoding: String.Encoding.utf8.rawValue)
			return decryptedStr
		}
		return nil
	}
}
