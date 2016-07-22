//
//  Event.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 1/6/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class DemoEvent {
    
    // MARK: Properties
    var eventId: Int32
    var name: String
    var date: String
    var startTime: String
    var endTime: String
    var club: String
    var address: String
    var music: String?
    var artist: String?
    var age: String
    var price: String
    var features: String?
    var promoterCount: String?
    // Newly added for promoter status upon invitaion sent by event creator
    // for promoter only
    var promoterStatus:String?
    
    
    // MARK: Initialization
    init?(eventId: Int32, name: String, date: String, startTime: String, endTime: String, club: String, address: String, music: String?, artist: String?, age: String, price: String, features: String?, promoterCount: String?, promoterStatus: String?) {
        self.eventId = eventId
        self.name = name
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.club = club
        self.address = address
        self.music = music
        self.artist = artist
        self.age = age
        self.price = price
        self.features = features
        self.promoterCount = promoterCount
        self.promoterStatus = promoterStatus
    
        if eventId < 1 || name.isEmpty || date.isEmpty || startTime.isEmpty || endTime.isEmpty || club.isEmpty || address.isEmpty || age.isEmpty || price.isEmpty {
            return nil
        }
    }
    
}
