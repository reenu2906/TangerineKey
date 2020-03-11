//
//  BLECentralManager.swift
//  TangerineKey
//
//  Created by Reenu Deswal on 06/03/20.
//  Copyright © 2020 Reenu Deswal . All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit


public protocol BLECeonnectionDelegate  : class{
    func gotConnected(state : ViewState)
}

public protocol BLEResponseDelegate : class {
    func receivedBLEResponse(state : CarState)
}


public enum ViewState {
    
    case getStarted
    case connecting
    case bluetoothPoweredOff
    case unauthorised
    case failedToConnect
    case connected
    case disconnected
    case validationFailed
    case slotExpired
}


public enum CarState: String {
    case notDetermined = "notDetermined"
    case locked        =  "#l"
    case unLocked      = "#u"
    
    var command: NSString {
        let timeString = (Date().timeIntervalSince1970*1000).cleanStringValue
        let message = BLEMessageContent.payload + BLEMessageContent.separator + BLEMessageContent.command +
            BLEMessageContent.separator + self.rawCommand + BLEMessageContent.separator + timeString as NSString
        
        return message
    }
    var rawCommand: String {
        switch self {
        case .locked:
            return "00"
        case .unLocked:
            return "01"
        default:
            return ""
        }
    }
}

public class BLECentralManager : NSObject {
    
    /*Our key player in this app will be our CBCentralManager. CBCentralManager objects are used to manage discovered or connected remote peripheral devices (represented by CBPeripheral objects), including scanning for, discovering, and connecting to advertising peripherals.
     */
    var centralManager : CBCentralManager!
    var characteristics = [String : CBCharacteristic]()
    var readWriteCharacteristic : CBCharacteristic?
    var blePeripheral : CBPeripheral?
   public static let sharedInstance = BLECentralManager()
   public weak var connectionDelegate : BLECeonnectionDelegate?
    public weak var messageDelegate : BLEResponseDelegate?
    
    
    private  override init(){
        centralManager = CBCentralManager.init()
    }
    
    public  func connectToPeripheral(phoneNumber : String, refNumber : String){
        centralManager.delegate = self
        validateBookingSlot(phoneNumber: phoneNumber, refNumber: refNumber)
    }
    
    public func disconnectFromPeripheral(){
        if let peripheral = blePeripheral {
            BLECentralManager.sharedInstance.centralManager?.cancelPeripheralConnection(peripheral)
        }
    }

    private var state:ViewState = .getStarted {
        didSet {
            didChangeViewState()
        }
    }
    
    func didChangeViewState()  {
        connectionDelegate?.gotConnected(state : self.state)
    }
    
    func refreshBLEState()  {
        switch BLECentralManager.sharedInstance.centralManager.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
            self.state = .unauthorised
        case .poweredOff:
            print("central.state is .poweredOff")
            self.state = .bluetoothPoweredOff
        case .poweredOn:
            self.state = .connecting
            print("central.state is .poweredOn")
            centralManager.delegate = self
            BLECentralManager.sharedInstance.centralManager.scanForPeripherals(withServices: [BLEService_UUID])
        }
    }
    
    func validateBookingSlot(phoneNumber : String, refNumber : String) {
        APIManager().validateSlot(phoneNumber: phoneNumber, refNumber: refNumber) { [weak self] (response, error) in
            if error != nil {
                self?.state = .validationFailed
            }
            else if  let loginResponse = response {
                DataManager.shared.authData = loginResponse
                DataManager.shared.obdID = loginResponse.obdId
                DataManager.shared.bookingReferenceID = refNumber
                DataManager.shared.phoneNumber = phoneNumber
                self?.state = .connecting
                self?.refreshBLEState()
            }
        }
    }
    
   public func lockUnlockCommand(state : CarState) {
       if isConnected() && isSlotValid(), let peripheral = blePeripheral{
        if let charecterstic = characteristics[kBLE_Characteristic_uuid_Read_Write.lowercased()] {
            if state == .locked {
                if let data = try? BLECentralManager.encryptedCommands(text: CarState.unLocked.command as String) {
                    peripheral.writeValue(data, for: charecterstic, type: CBCharacteristicWriteType.withResponse)
                }
            } else if state == .unLocked {
                if let data = try? BLECentralManager.encryptedCommands(text: CarState.locked.command as String) {
                    peripheral.writeValue(data, for: charecterstic, type: CBCharacteristicWriteType.withResponse)
                }
            }
        }
        
        }
        else if !isSlotValid() {
            self.state = .slotExpired
       } else {
        disconnectFromPeripheral()
    }
        
    }
    
    public func isConnected() -> Bool {
        if self.state == .connected {
            return true
        }
        return false
    }
    
    public func isSlotValid() -> Bool {
        if let authData = DataManager.shared.authData, authData.isSessionExpired  {
            return false
        }
         return true
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
    
    // -------------------------
    // MARK: - BLE Response processing
    // -------------------------
    func didReceiveResponseFromBLE(response: String) {
          if response == CarState.unLocked.rawValue {
            messageDelegate?.receivedBLEResponse(state: .unLocked)
        } else if response == CarState.locked.rawValue {
           messageDelegate?.receivedBLEResponse(state: .locked)
          }else {
            messageDelegate?.receivedBLEResponse(state: .notDetermined)
        }
        
    }
}
    
    extension BLECentralManager : CBCentralManagerDelegate {
        
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("central state is changing")
        refreshBLEState()
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name?.lowercased() == DataManager.shared.authData?.veicleNumber.lowercased() {
            BLECentralManager.sharedInstance.blePeripheral = peripheral
            BLECentralManager.sharedInstance.blePeripheral?.delegate = self
            central.stopScan()
            central.connect(peripheral)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([BLEService_UUID])
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral! = \(error?.localizedDescription ?? "")")
        if let error = error {
           print("error while disconnecting \(error.localizedDescription)")
        } else{
            DataManager.shared.clearAllData()
            self.state = .disconnected
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.state = .failedToConnect
    }
    
}


extension BLECentralManager : CBPeripheralDelegate {
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)
            
            if characteristic.properties.contains(.write) {
                print("\(characteristic.uuid): properties contains .read")
                BLECentralManager.sharedInstance.characteristics[characteristic.uuid.uuidString.lowercased()] = characteristic
                self.state = .connected
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
       /* if let error = error {
            AlertHandler.showAlert(withTitle: "Error", message: error.localizedDescription, cancelButtonTitle: "OK")
            self.state = .writingFailed
        } */
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            debugPrint("didUpdateValueFor Error: \(error.localizedDescription)")
        } else if let data = characteristic.value, let response = String(data: data, encoding: .utf8)?.lowercased(), !response.isEmpty {
                debugPrint("Data : \(String(describing: String(data: data, encoding: .utf8)))")
                didReceiveResponseFromBLE(response: response)
            }
    }
}
