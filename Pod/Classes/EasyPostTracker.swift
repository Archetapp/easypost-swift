//
//  EasyPostTracker.swift
//  AKPickerView-Swift
//
//  Created by Davidson Family on 1/29/18.
//

import Foundation

open class EasyPostTracker {
    open var id:String?
    open var estimatedDelivery:Date?
    open var carrier:String?
    open var createdAt:Date?
    open var updatedAt:Date?
    open var tracking_details : [trackingDetail]?
    
    public init() {
        
    }
    
    public init(jsonDictionary: [String: Any]) {
        //Load the JSON dictionary
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"   //2013-04-22T05:40:57Z
        
        if let stringValue = jsonDictionary["id"] as? String {
            id = stringValue
        }
        
        if let stringValue = jsonDictionary["carrier"] as? String {
            carrier = stringValue
        }
        
        if let stringValue = jsonDictionary["est_delivery_date"] as? String {
            estimatedDelivery = dateFormatter.date(from: stringValue)
        }
        
        if let stringValue = jsonDictionary["created_at"] as? String {
            createdAt = dateFormatter.date(from: stringValue)
        }
        
        if let stringValue = jsonDictionary["updated_at"] as? String {
            updatedAt = dateFormatter.date(from: stringValue)
        }
        
        if let trackingDetailsDictionary = jsonDictionary["tracking_details"] as? [[String : Any]] {
            for dict in trackingDetailsDictionary {
                if tracking_details == nil {
                    tracking_details = [trackingDetail(jsonDictionary: dict)]
                } else {
                    tracking_details?.append(trackingDetail(jsonDictionary: dict))
                }
            }
        }
        
        
    }
    
}


open class trackingDetail {
    open var object : String?
    open var message : String?
    open var status : String?
    open var date : Date?
    open var source : String?
    open var progress : Double?
    open var progressColor : CGColor?
    open var trackingLocation : TrackingLocation?
    
    public init() {
        
    }
    
    public init(jsonDictionary: [String: Any]) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"   //2013-04-22T05:40:57Z
        
        if let stringObject = jsonDictionary["object"] as? String {
            object = stringObject
        }
        if let stringObject = jsonDictionary["message"] as? String {
            message = stringObject
        }
        if let stringObject = jsonDictionary["status"] as? String {
            switch stringObject {
            case "unknown" :
                progress = 0
                progressColor = UIColor.universalBlue.cgColor
                break
            case "pre_transit" :
                progress = 0.2
                progressColor = UIColor.universalBlue.cgColor
                break
            case "in_transit" :
                progress = 0.5
                progressColor = UIColor.universalBlue.cgColor
                break
            case "out_for_delivery" :
                progress = 0.7
                progressColor = UIColor.universalBlue.cgColor
                break
            case "delivered" :
                progress = 0.7
                progressColor = UIColor.universalGreen.cgColor
                break
            case "available_for_pickup" :
                progress = 1
                progressColor = UIColor.universalGreen.cgColor
                break
            case "return_to_sender" :
                progress = 0
                progressColor = UIColor.universalRed.cgColor
                break
            case "failure" :
                progress = 1
                progressColor = UIColor.universalRed.cgColor
                break
            case "cancelled" :
                progress = 1
                progressColor = UIColor.universalRed.cgColor
                break
            case "error" :
                progress = 0
                progressColor = UIColor.universalRed.cgColor
                break
            default :
                
                break
            }
            
            status = stringObject
        }
        if let stringObject = jsonDictionary["source"] as? String {
            source = stringObject
        }
        if let dateString = jsonDictionary["datetime"] as? String {
            date = dateFormatter.date(from: dateString)
        }
        
        if let trackingLocationDictionary = jsonDictionary["tracking_details"] as? NSDictionary {
            trackingLocation = TrackingLocation(jsonDictionary: trackingLocationDictionary)
            
        }
        
    }
}

open class TrackingLocation {
    open var city : String?
    open var state : String?
    open var country : String?
    open var zip : String?
    init() {
        
    }
    
    public init(jsonDictionary: NSDictionary) {
        if let stringObject = jsonDictionary["city"] as? String {
            city = stringObject
        }
        if let stringObject = jsonDictionary["state"] as? String {
            state = stringObject
        }
        if let stringObject = jsonDictionary["country"] as? String {
            country = stringObject
        }
        if let stringObject = jsonDictionary["zip"] as? String {
            zip = stringObject
        }
    }
}



let universalSuperLightGreyString : String = "EDEDED"
let universalLighterGreyString : String = "D4D4D4"
let universalLightGreyString : String = "95a5a6"
let universalGreyString : String = "767676"
let universalRedString : String = "e74c3c"
let universalBlueString : String = "4A90E2"
let universalBlackString : String = "2E2E2E"
let universalGreenString : String = "8DDE71"


extension UIColor {
    static let universalSuperLightGrey = hexStringToUIColor(hex: universalSuperLightGreyString)
    static let universalLighterGrey = hexStringToUIColor(hex: universalLighterGreyString)
    static let universalLightGrey = hexStringToUIColor(hex: universalLightGreyString)
    static let universalGrey = hexStringToUIColor(hex: universalGreyString)
    static let universalRed = hexStringToUIColor(hex: universalRedString)
    static let universalBlue = hexStringToUIColor(hex: universalBlueString)
    static let universalBlack = hexStringToUIColor(hex: universalBlackString)
    static let universalGreen = hexStringToUIColor(hex: universalGreenString)
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
