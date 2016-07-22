//
//  Price+CoreDataProperties.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 2/24/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.

import Foundation
import CoreData

extension Price {

    @NSManaged var from: String?
    @NSManaged var to: String?
    @NSManaged var fee: String?
    @NSManaged var event: Event?

}
