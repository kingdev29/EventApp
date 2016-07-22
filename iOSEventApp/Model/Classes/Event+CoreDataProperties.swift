//
//  Event+CoreDataProperties.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 3/17/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var area: String?
    @NSManaged var artists: String?
    @NSManaged var club: String?
    @NSManaged var country: String?
    @NSManaged var end_date: String?
    @NSManaged var end_time: String?
    @NSManaged var entrance_fee: String?
    @NSManaged var features: String?
    @NSManaged var genres: String?
    @NSManaged var id: NSNumber?
    @NSManaged var label: String?
    @NSManaged var min_age: String?
    @NSManaged var name: String?
    @NSManaged var promoter_status: String?
    @NSManaged var start_date: String?
    @NSManaged var start_time: String?
    @NSManaged var state: String?
    @NSManaged var type: String?
    @NSManaged var active_promoter_count: String?
    @NSManaged var prices: NSSet?

}
