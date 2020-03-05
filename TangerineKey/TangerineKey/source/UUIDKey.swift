//
//  UUIDKey.swift
//  JIDO KEY
//
//  Created by Reenu Deswal on 21/03/19.
//

import CoreBluetooth
//Uart Service uuid

// uses base UUID 00000000-0000-1000-8000-00805F9B34FB (default for hm-10 and clones)
// service uuid ffe0, characteristic uuid ffe1. can be set in code.

private let kBLEService_UUID = "0000ffe7-0000-1000-8000-00805f9b34fb"
let kBLE_Characteristic_uuid_Read_Write = "FFE9"
//let kBLE_Characteristic_uuid_Rx = "0000ffe9-0000-1000-8000-00805f9b34fb"
let MaxCharacters = 50

let BLEService_UUID = CBUUID(string: kBLEService_UUID)
let BLE_Characteristic_uuid_Read_Write = CBUUID(string: kBLE_Characteristic_uuid_Read_Write)//(Property = Write without response) (Property = Read/Notify)

//let BLE_Characteristic_uuid_Rx = CBUUID(string: kBLE_Characteristic_uuid_Rx)// (Property = Read/Notify)

