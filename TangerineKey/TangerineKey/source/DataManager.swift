//
//  DataManager.swift
//  TangerineKey
//
//  Created by Reenu Deswal on 06/03/20.
//  Copyright © 2020 Reenu Deswal . All rights reserved.
//


import Foundation

public class DataManager {
	
	public static let shared = DataManager()
	
	public var bookingReferenceID: String? {
		get {
			return UserDefaults.standard.value(forKey: "bookingReferenceID") as? String
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "bookingReferenceID")
		}
	}
	
	public var phoneNumber: String? {
		get {
			return UserDefaults.standard.value(forKey: "phoneNumber") as? String
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "phoneNumber")
		}
	}
	
	public var authData: AuthModel? {
		get {
			if let data = UserDefaults.standard.value(forKey:"authData") as? Data {
				return try? PropertyListDecoder().decode(AuthModel.self, from: data)
			}
			return nil
		}
		set {
			UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey:"authData")

		}
	}
	public var peripheralID: String? {
		get {
			return UserDefaults.standard.value(forKey: "peripheralID") as? String
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "peripheralID")
		}
	}
    
    public var peripheralName : String? {
        get {
            return UserDefaults.standard.value(forKey: "peripheralName") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "peripheralName")
        }
        
    }
    
    public var obdID : String? {
        get {
            return UserDefaults.standard.value(forKey: "obdID") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "obdID")
        }
    }
    
    public var bookingEndtime : Double? {
        get {
            return UserDefaults.standard.value(forKey: "bookingEndtime") as? Double
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "bookingEndtime")
        }
    }
	
	public var isDeviceConfigured: Bool {
		return peripheralID != nil && peripheralID != ""
	}
	private init(){

	}
	
	public func clearAllData()  {
		peripheralID = nil
		authData = nil
		phoneNumber = nil
		bookingReferenceID = nil
	}
}
