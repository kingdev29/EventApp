//
//  Networking.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 1/20/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PKHUD

protocol LoginDelegate {
    func loginDidSucceed(authToken: String?, userType: String?)
    func loginAuthenticationDidFail()
    func loginDidFail(error: NSError?, message: String?)
}

protocol AddContactDelegate {
    func addContactDidSucceed(statusCode:Int32)
    func addContactDidFailed(error:NSError)
}

protocol DeleteContactDelegate {
    func deleteContactDidSucceed(data:JSON)
    func deleteContactDidFail(error:NSError)
}


protocol ShowAddressListDelegate {
    func showAddressDidSucceed(data:JSON)
    func showAddressDidFailed(error:NSError)
}

protocol AddEventDelegate {
    func addEventDidSucceed(data:JSON)
    func addEventDidFail(error:NSError)
}

protocol DeleteEventDelegate {
    func deleteEventDidSucceed(data: JSON)
    func deleteEventDidFail(error:NSError)
}

protocol GetAllEventsDelegate {
    func getAllEventDidSucceed(data:JSON)
    func getAllEventDidFail(error:NSError)
}

protocol GetMyPromotersDelegate {
    func getMyPromotersDidSucceed(data:JSON)
    func getMyPromotersDidFail(error:NSError)
}

protocol AssignPromotersToEventDelegate{
    func AssignPromotersToEventDidSucceed(data:JSON)
    func AssignPromotersToEventDidFail(error:NSError)
}

protocol AcceptInvitaionInEventDelegate {
    func acceptInvitaionInEventDidSucceed(data:JSON)
    func acceptInvitaionInEventDidFail(error:NSError)
}

protocol GetAllLabelListDelegate {
    func labelListingDidSucced(data: JSON)
    func labelListingDidFail(error: NSError)
}

class Networking {
    
    // MARK: Properties
    static var loginDelegate: LoginDelegate?
    static var contactDelegate: AddContactDelegate?
    static var deleteContact: DeleteContactDelegate?
    static var addressDelegate: ShowAddressListDelegate?
    static var addEventDelegate: AddEventDelegate?
    static var deleteEventDelegate: DeleteEventDelegate?
    static var getAllEventsDelegate : GetAllEventsDelegate?
    static var getMyPromotersDelegate: GetMyPromotersDelegate?
    static var assignPromotersToEventDelegate: AssignPromotersToEventDelegate?
    static var acceptInvitationInEventDelegate: AcceptInvitaionInEventDelegate?
    static var labelListingDelegate: GetAllLabelListDelegate?
    
    // MARK: Custom Methods
    class func login(email: NSString!, password: NSString!) {
        let parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(.POST, Constants.baseUrl + "api/login", parameters: parameters)
            .response { (request, response, data, error) in
                print("Response")
                print(response)
                
                // Check for error
                if error != nil {
                    print("Error:")
                    print(error)
                    self.loginDelegate?.loginDidFail(error!, message: nil)
                } else {
                    let json = JSON(data: data!)
                    print(json)
                    // Check for valid "status" key
                    if let status = json["status"].string {
                        if status == "success" {
                            print(json)
                            if let data = json["data"].array {
                                print("user data")
                                print(data[0])
                                if let authToken = data[0]["auth_token"].string, userType = data[0]["type_text"].string {
                                    self.loginDelegate?.loginDidSucceed(authToken, userType: userType)
                                } else {
                                    print("Invalid json key:")
                                    self.loginDelegate?.loginDidFail(nil, message: "Invalid json key")
                                    
                                }
                            } else {
                                print("Invalid json key:")
                                self.loginDelegate?.loginDidFail(nil, message: "Invalid json key")
                                
                            }
                        } else {
                            print(json)
                            self.loginDelegate?.loginAuthenticationDidFail()
                        }
                    } else {
                        print("Invalid json key:")
                        self.loginDelegate?.loginDidFail(nil, message: "Invalid json key")
                    }
                }
        }
    }
    
    class func deleteContact(contactId:Int){
        let defaults = NSUserDefaults.standardUserDefaults()
        print(contactId)
        if let token = defaults.stringForKey(Constants.authToken) {
            let headers = [ "token":"\(token)",
                            "Accept":"application/json"]
            Alamofire
                .request(.DELETE, Constants.baseUrl + "api/contact/\(contactId)",encoding: .URL, headers: headers)
                .response { (request, response, data, error) in
                    if error != nil{
                        print(error)
                        self.deleteContact?.deleteContactDidFail(error!)
                        return
                    }
                    let  jsonData = JSON(data: data!)
                    self.deleteContact?.deleteContactDidSucceed(jsonData)
            }
            
        }
    }
    
    class func addContact(contact: Contact, eventId: NSNumber?, contactId:NSNumber?){
        var alamofireMethod:Alamofire.Method
        var link:String!
        
        if let contact_id = contactId {
            alamofireMethod = .POST
            link = "api/contact/\(contact_id)"
        }
        else {
            alamofireMethod = .POST
            link = "api/event/\(eventId!)/contact"
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.stringForKey(Constants.authToken) {
            let headers = [ "token":"\(token)",
                            "Accept":"application/json"]
            let parameters = [
                "first_name" : contact.firstName,
                "last_name" : contact.surName,
                "email" : contact.emailAddress,
                "gender" : contact.sex,
                "dob" : contact.dob,
                "phone":contact.phone
            ]
            Alamofire
                .request(alamofireMethod, Constants.baseUrl + link, parameters:parameters,encoding: .URL, headers: headers)
                .response { (request, response, data, error) in
                    if error != nil{
                        print(error)
                        self.contactDelegate?.addContactDidFailed(error!)
                        return
                    }
                    let  jsonData = JSON(data: data!)
                    print(jsonData)
                    let status_code = jsonData["status_code"].int32!
                    self.contactDelegate?.addContactDidSucceed(status_code)
            }
        }
    }
    
    class func addEvent(event:[String: AnyObject],eventPrices: [(From: String,To: String,Price: String)],eventId:NSNumber?) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.stringForKey(Constants.authToken) {
            let headers = [ "token":token,
                            "Accept":"application/json"]
            var priceRange:[String:String] = [:]
            let prices:NSMutableArray = []
            var jsonPrice:NSString!
            if eventPrices.count > 0 {
                for i in 0 ... eventPrices.count - 1 {
                    priceRange["from"] = eventPrices[i].From
                    priceRange["to"] = eventPrices[i].To
                    priceRange["price"] = eventPrices[i].Price
                    prices.addObject(priceRange)
                }
                do{
                    let tempData = try NSJSONSerialization.dataWithJSONObject(prices, options: NSJSONWritingOptions(rawValue: 0))
                    jsonPrice = NSString(data: tempData, encoding: NSUTF8StringEncoding)
                }catch _{
                }
            }else{
                jsonPrice = ""
            }
            print(event)
            let parameters = [
                "name" : event["name"]!  ,
                "club" : event["club"]! ,
                "address" : event["address"]!,
                "start_date" : event["start_date"]!,
                "end_date" : event["end_date"]!,
                "min_age" : event["min_age"]!,
                "label" : event["label"]!,
                "artists":event["artists"]!,
                "genres" : event["genres"]!,
                "entrance_fee" : event["entrance_fee"]!,
                "prices" : jsonPrice,
                "features" : event["features"]!
            ]
            print(parameters)
            
            var alamofireMethod:Alamofire.Method
            var link:String
            if let event_id = eventId{
                alamofireMethod = .PUT
                link = "api/event/\(event_id)"
            }else{
                alamofireMethod = .POST
                link = "api/event"
            }
            
            Alamofire
                .request(alamofireMethod, Constants.baseUrl + link,parameters:parameters,encoding: .URL, headers: headers)
                .response { (request, response, data, error) in
                    if error != nil{
                        print(error?.localizedDescription)
                        self.addEventDelegate?.addEventDidFail(error!)
                        return
                    }
                    let  jsonData = JSON(data: data!)
                    print(jsonData)
                    self.addEventDelegate?.addEventDidSucceed(jsonData)
                    
            }
            
            
        }
        
    }
    
    class func deleteEvent(eventId: NSNumber) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.stringForKey(Constants.authToken) {
            let headers = [ "token":"\(token)",
                            "Accept":"application/json"]
            Alamofire
                .request(.DELETE, Constants.baseUrl+"api/event/\(eventId)", encoding: .URL, headers: headers)
                .response { (request, response, data, error) in
                    if error != nil{
                        print("delete event error=\(error)")
                        self.deleteEventDelegate?.deleteEventDidFail(error!)
                        return
                    }
                    let  jsonData = JSON(data: data!)
                    print("delete event=\(jsonData)")
                    self.deleteEventDelegate?.deleteEventDidSucceed(jsonData)
            }
        }
    }
    
    class func getAllAddress() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.stringForKey(Constants.authToken) {
            let headers = [ "token":"\(token)",
                            "Accept":"application/json"]
            Alamofire
                .request(.GET, Constants.baseUrl+"api/contact",encoding: .URL, headers: headers)
                .response { (request, response, data, error) in
                    if error != nil{
                        print("getalladdresserror=\(error)")
                        self.addressDelegate?.showAddressDidFailed(error!)
                        return
                    }
                    let  jsonData = JSON(data: data!)
                    print("getalladdresssuccess=\(jsonData)")
                    self.addressDelegate?.showAddressDidSucceed(jsonData)
                    
            }
        }
    }
    
    class func getAllEvent(maxUpdatedDate: String) {
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: "Events aktualisieren...")
        PKHUD.sharedHUD.show()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.stringForKey(Constants.authToken) {
            let userType = defaults.stringForKey(Constants.userType)!
            let parameters = [
                "max_updated_date": maxUpdatedDate,
                ]
            
            let url = (userType == "Promoter" ? "api/promoter/event" : "api/events?expands=features,country,genres")
            let headers = [ "token":"\(token)",
                            "Accept":"application/json"]
            Alamofire
                .request(.GET, Constants.baseUrl + url, parameters: parameters, encoding: .URL, headers: headers)
                .response { (request, response, data, error) in
                    print("request: \n \(request)")
                    
                    PKHUD.sharedHUD.hide()
                    
                    if error != nil{
                        self.getAllEventsDelegate?.getAllEventDidFail(error!)
                        return
                    }
                    let  jsonData = JSON(data: data!)
                    print("getallevent=\(jsonData)")
                    self.getAllEventsDelegate?.getAllEventDidSucceed(jsonData)
                    
            }
        }
    }
    
    class func getMyPromoters(eventId: NSNumber) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.stringForKey(Constants.authToken) {
            let headers = [ "token":"\(token)",
                            "Accept":"application/json"]
            Alamofire
                .request(.GET, Constants.baseUrl+"api/event/\(eventId)/promoters",encoding: .URL, headers: headers)
                .response { (request, response, data, error) in
                    if error != nil{
                        self.getMyPromotersDelegate?.getMyPromotersDidFail(error!)
                        return
                    }
                    let  jsonData = JSON(data: data!)
                    print(jsonData)
                    self.getMyPromotersDelegate?.getMyPromotersDidSucceed(jsonData)
            }
        }
        
    }
    
    class func assignPromotersToEvent(promoters: [Int], eventId: NSNumber){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.stringForKey(Constants.authToken) {
            let headers = [ "token":"\(token)",
                            "Accept":"application/json"]
            let parameters = [
                "promoters" : promoters
            ]
            Alamofire
                .request(.POST, Constants.baseUrl + "api/event/\(eventId)/promoter/assign",parameters:parameters,encoding: .URL, headers: headers)
                .response { (request, response, data, error) in
                    if error != nil{
                        print(error)
                        self.assignPromotersToEventDelegate?.AssignPromotersToEventDidFail(error!)
                        return
                    }
                    let  jsonData = JSON(data: data!)
                    self.assignPromotersToEventDelegate?.AssignPromotersToEventDidSucceed(jsonData)
            }
        }
        
    }
    
    class func acceptEventInvitationByPromoter(eventId: NSNumber) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.stringForKey("authToken") {
            let headers = [ "token":"\(token)",
                            "Accept":"application/json"]
            Alamofire
                .request(.GET, Constants.baseUrl + "api/event/\(eventId)/promoter/accept",encoding: .URL, headers: headers)
                .response { (request, response, data, error) in
                    if error != nil{
                        print(error)
                        //  self.contactDelegate?.addContactDidFailed(error!)
                        self.acceptInvitationInEventDelegate?.acceptInvitaionInEventDidFail(error!)
                        return
                    }
                    let  jsonData = JSON(data: data!)
                    print(jsonData)
                    self.acceptInvitationInEventDelegate?.acceptInvitaionInEventDidSucceed(jsonData)
                    //self.contactDelegate?.addContactDidSucceed(status_code)
            }
        }
        
    }
    
    class func getLabelList() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.stringForKey(Constants.authToken) {
            let headers = [ "token":"\(token)",
                            "Accept":"application/json"]
            Alamofire
                .request(.GET, Constants.baseUrl+"api/event/label-eventgoers/count",encoding: .URL, headers: headers)
                .response { (request, response, data, error) in
                    if error != nil{
                        self.labelListingDelegate?.labelListingDidFail(error!)
                        return
                    }
                    let  jsonData = JSON(data: data!)
                    print(jsonData)
                    self.labelListingDelegate?.labelListingDidSucced(jsonData)
            }
        }
        
    }
    
}
