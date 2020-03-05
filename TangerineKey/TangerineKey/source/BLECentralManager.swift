//
//  BLECentralManager.swift
//  Nano bot
//
//  Created by Reenu Deswal on 21/03/19.
//  Copyright © 2019 neva. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class BLECentralManager {
    
    /*Our key player in this app will be our CBCentralManager. CBCentralManager objects are used to manage discovered or connected remote peripheral devices (represented by CBPeripheral objects), including scanning for, discovering, and connecting to advertising peripherals.
     */
    var centralManager : CBCentralManager!
    var characteristics = [String : CBCharacteristic]()
    
    var readWriteCharacteristic : CBCharacteristic?
    var blePeripheral : CBPeripheral?
    
    static let sharedInstance = BLECentralManager()
    
    private init(){
        centralManager = CBCentralManager.init()
    }

	class func openBLEPreference() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            // Handling errors that should not happen here
            return
        }
        let app = UIApplication.shared
        app.open(url, options: [:], completionHandler: nil)
	}
	
	class func encryptedCommandFor(text: String) throws -> Data {
        let timeString = (Date().timeIntervalSince1970*1000).cleanStringValue
        var message = NSString()
        if text == DataManager.shared.obdID {
             message = BLEMessageContent.payload + BLEMessageContent.separator + BLEMessageContent.obdID +
                BLEMessageContent.separator + text + BLEMessageContent.separator + timeString as NSString
            
        } else if text == DataManager.shared.bookingReferenceID {
             message = BLEMessageContent.payload + BLEMessageContent.separator + BLEMessageContent.bookID +
                BLEMessageContent.separator + text + BLEMessageContent.separator + timeString as NSString
        }
		
		debugPrint("Init message = \(message)")
			guard let dataStr = DESEncryptor.doCipher(encryptValue: message), let data = (dataStr + BLEMessageContent.eom).data(using: .utf8) else {
				throw APIError.dataFormatError(message: "No data")
			}
			return data
	}
    
    class func encryptedCommands(text : String) throws -> Data {
        var message = NSString()
        if let obd = DataManager.shared.obdID, let bookingId = DataManager.shared.bookingReferenceID {
            let message2 = BLEMessageContent.separator + bookingId + BLEMessageContent.separator + obd
            message = text + message2 as NSString
        }
        debugPrint("Init message = \(message)")
        guard let dataStr = DESEncryptor.doCipher(encryptValue: message), let data = (dataStr + BLEMessageContent.eom).data(using: .utf8) else {
            throw APIError.dataFormatError(message: "No data")
        }
        return data
    }
}
