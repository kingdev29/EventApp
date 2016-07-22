//
//  Constants.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 1/11/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

struct Constants {
    // Color
    static let navigationBarTintColor = UIColor(colorLiteralRed: 21.0/255, green: 28.0/255, blue: 56.0/255, alpha: 1.0)
    static let brightBlueColor = UIColor(colorLiteralRed: 72.0/255, green: 163.0/255, blue: 237.0/255, alpha: 1.0)
    
    // Segues
    static let showEventDetails: String = "showEventDetails"
    static let showEventList: String = "showEventList"
    static let showCreateEvent: String = "showCreateEvent"
    static let showCreateEventFromList: String = "showCreateEventFromList"
    static let showPromoterListFromEventListView: String = "showPromoterListFromEventList"
    static let showPromoterListFromEventDetailsView: String = "showPromoterListFromEventDetails"
    static let showContactDetails:String = "showContactDetails"
    static let showContactList:String = "showContactList"
    static let showEditEvent:String = "showEditEvent"
    static let showAddContactFromEventList: String = "showAddContactViewFromEventListView"
    static let showAddContactFromEventDetails: String = "showAddContactViewFromEventDetailsView"
    static let showLabelListing: String = "showLabelListing"
    static let showEmailInvitation:String = "showEmailInvitation"
    static let showQRCodeFromEventList: String = "showQRCodeFromEventList"
    
    
    // User type
    static let administrator: String = "Administrator"
    static let promoter: String = "Promoter"
    
    // NSUserDefaults keys
    static let authToken: String = "authToken"
    static let userType: String = "userType"
    static let eventMaxUpdatedDate: String = "eventMaxUpdatedDate"
    static let eventForEdit:String = "eventForEdit"
      static let showEditContact:String = "editContact"
    
    // Network api
    static let baseUrl:String = "http://event-stage.slctn.us/"
//    static let baseUrl:String = "http://eventapp.slctn.us/"
}

struct GlobalVariables {
    
    static var createEventData = [String: AnyObject]()
    static var priceStaffelung = [(From: "",To: "",Price: "")]
    static var editEventData:Event!
    
}

struct GlobalFunctions {
    static func formatDate(eventDate: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.dateFromString(eventDate)
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "de_DE")
        
        let strDate = dateFormatter.stringFromDate(date!)
        
        return strDate
    }
    
    static func formatTime(eventTime: String) -> String {
        let formattedTime = eventTime.substringToIndex(eventTime.startIndex.advancedBy(5))
        return formattedTime
    }
    
    
}
