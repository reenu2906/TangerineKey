//
//  DataManager.swift
//  JIDO KEY
//
//  Created by Arshad on 05/04/19.
//

import Foundation

class DataManager {
	
	static let shared = DataManager()
	
	var bookingReferenceID: String? {
		get {
			return UserDefaults.standard.value(forKey: "bookingReferenceID") as? String
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "bookingReferenceID")
		}
	}
	
	var phoneNumber: String? {
		get {
			return UserDefaults.standard.value(forKey: "phoneNumber") as? String
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "phoneNumber")
		}
	}
	
	var authData: AuthModel? {
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
	var peripheralID: String? {
		get {
			return UserDefaults.standard.value(forKey: "peripheralID") as? String
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "peripheralID")
		}
	}
    
    var peripheralName : String? {
        get {
            return UserDefaults.standard.value(forKey: "peripheralName") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "peripheralName")
        }
        
    }
    
    var obdID : String? {
        get {
            return UserDefaults.standard.value(forKey: "obdID") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "obdID")
        }
    }
    
    var bookingEndtime : Double? {
        get {
            return UserDefaults.standard.value(forKey: "bookingEndtime") as? Double
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "bookingEndtime")
        }
    }
	
	var isDeviceConfigured: Bool {
		return peripheralID != nil && peripheralID != ""
	}
	private init(){

	}
	
	func clearAllData()  {
		peripheralID = nil
		authData = nil
		phoneNumber = nil
		bookingReferenceID = nil
	}
}
