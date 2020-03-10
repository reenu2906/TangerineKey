//
//  UUIDKey.swift
//  TangerineKey
//
//  Created by Reenu Deswal on 06/03/20.
//  Copyright © 2020 Reenu Deswal . All rights reserved.
//


import CoreBluetooth


private let kBLEService_UUID = "0000ffe7-0000-1000-8000-00805f9b34fb"
let kBLE_Characteristic_uuid_Read_Write = "FFE9"
let MaxCharacters = 50

let BLEService_UUID = CBUUID(string: kBLEService_UUID)
let BLE_Characteristic_uuid_Read_Write = CBUUID(string: kBLE_Characteristic_uuid_Read_Write)//(Property = Write without response) (Property = Read/Notify)


