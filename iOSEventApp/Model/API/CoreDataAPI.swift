//
//  CoreDataAPI.swift
//  iOSEventApp
//
//  Created by Kiran Thapa on 2/26/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

/*
    CoreDataAPI contains endpoints to Create/Read/Update/Delete core data model objects.
*/

class CoreDataAPI: NSObject {
    
    let managedContext: NSManagedObjectContext!
    let persistentStoreCoordinator: NSPersistentStoreCoordinator!
    
    override init() {
        let appDelegate : AppDelegate = AppDelegate().sharedInstance()
        self.managedContext = appDelegate.managedObjectContext
        self.persistentStoreCoordinator = appDelegate.persistentStoreCoordinator
        super.init()
    }
    
    
    // Utilize Singleton pattern by instanciating EventAPI only once.
    class var sharedInstance: CoreDataAPI {
        struct Singleton {
            static let instance = CoreDataAPI()
        }
        
        return Singleton.instance
    }
    
    /*
        @brief Save json event data returned by server.
        @discussion
        @param eventJSON Event data returned from server.
        @return void
    */
    func saveEvent(eventJSON: JSON) {
        if let eventArray = eventJSON["data"].array {
            if eventArray.count > 0 {
                let messageDictionary = eventJSON["message"].dictionary
                let eventMaxUpdatedDate = messageDictionary!["event_max_updated_date"]!.string
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(eventMaxUpdatedDate, forKey: Constants.eventMaxUpdatedDate)
                defaults.synchronize()

            }
            for singleEventInfo in eventArray {
                var eventItem: Event!
                
                // Check if event with this "id" already exists
                if let event = self.getEventById(singleEventInfo["id"].number!) {
                    self.deleteEvent(event.id!)
                }
                
                // Create new Object of Event entity
                eventItem = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: self.managedContext) as? Event
                
                // Set event associated user
                let defaults = NSUserDefaults.standardUserDefaults()
                if let userType = defaults.stringForKey(Constants.userType) {
                    if userType == Constants.administrator {
                        eventItem.type = "Administrator"
                        eventItem.promoter_status = nil
                    } else {
                        eventItem.type = "Promoter"
                        eventItem.promoter_status = singleEventInfo["event_status"].string
                    }
                } else {
                    print("User type not set")
                }
                
                
                // Set event's random details
                eventItem.id = singleEventInfo["id"].number
                eventItem.name = singleEventInfo["name"].string
                eventItem.club = singleEventInfo["club"].string
                eventItem.entrance_fee = singleEventInfo["entrance_fee"].string
                eventItem.min_age = singleEventInfo["min_age"].string
                eventItem.label = singleEventInfo["label"].string
                eventItem.active_promoter_count = singleEventInfo["active_promoter_count"].string
                
                // Set event's date/time information
                eventItem.start_date = singleEventInfo["event_start_date"].string
                eventItem.end_date = singleEventInfo["event_end_date"].string
                eventItem.start_time = singleEventInfo["event_start_time"].string
                eventItem.end_time = singleEventInfo["event_end_time"].string
                
                // Set event's address
                let addressDictionary = singleEventInfo["address"].dictionary
                eventItem.state = addressDictionary!["state"]?.string
                eventItem.area = addressDictionary!["area"]?.string
                eventItem.country = addressDictionary!["country"]?.string
                
                // Set event's artist
                let artistArray: [String] = singleEventInfo["artists"].arrayValue.map{$0.string!}
                eventItem.artists = artistArray.joinWithSeparator(", ")
                
                // Set event's genres
                var genresArray: [String] = []
                for genreDictionary in singleEventInfo["genres"].array! {
                    genresArray.append(genreDictionary["title"].string!)
                }
                eventItem.genres = genresArray.joinWithSeparator(", ")
                
                // Set event's features
                var featuresArray: [String] = []
                for featureDictionary in singleEventInfo["features"].array! {
                    featuresArray.append(featureDictionary["title"].string!)
                }
                
                if !featuresArray.isEmpty {
                    eventItem.features = featuresArray.joinWithSeparator(", ")
                }
                
                // Set event's prices
                let pricesArray = singleEventInfo["prices"].array
                for price in pricesArray! {
                    let priceItem = NSEntityDescription.insertNewObjectForEntityForName("Price", inManagedObjectContext: self.managedContext) as! Price
                    priceItem.from = price["from"].string
                    priceItem.to = price["to"].string
                    priceItem.fee = price["price"].string
                    priceItem.event = eventItem
                }
                
                // Save event
                do {
                    try self.managedContext.save()
                    print("Event saved")
                    self.getEvents()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            }
        }
    }
    
    /*
    @brief  Update event for promoter
    @discussion
    @param  eventId
            promoterStatus
    @return None
    */
    
    func updateEvent(eventId: NSNumber, promoterStatus: String) {
        if let event = self.getEventById(eventId) {
            event.promoter_status = promoterStatus
            
            // Save event
            do {
                try self.managedContext.save()
                print("Event saved")
                self.getEventById(eventId)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
    }
    
    
    
    /*
    @brief Fetch events from core data storage.
    @discussion
    @param None
    @return Array of events
    */
    
    func getEvents() -> [Event] {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedContext)
        
        // Create predicate to get relevant events
        let defaults = NSUserDefaults.standardUserDefaults()
        let pred = NSPredicate(format: "type = %@", defaults.stringForKey(Constants.userType)!)
        fetchRequest.predicate = pred
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.managedContext.executeFetchRequest(fetchRequest)
            if (result.count > 0) {
                return result as! [Event]
                
            } else {
                print("no events")
                return []
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return []
        }
    }
    
    /*
    @brief Fetch events from core data storage by id.
    @discussion
    @param Possible event id
    @return Event with particular id or nil if no event with specified id is found
    */
    
    func getEventById(id: NSNumber) -> Event? {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedContext)
        
        // Create predicate for filtering events by id
        let pred = NSPredicate(format: "id = %@", id)
        fetchRequest.predicate = pred
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        var fetchedEvent: Event?
        
        do {
            let result = try self.managedContext.executeFetchRequest(fetchRequest)
            
            if (result.count > 0) {
                for event in result {
                    print("######## Event #######")
                    print("\n id: \(event.valueForKey("id")) \n name: \(event.valueForKey("name")) \n p_status: \(event.valueForKey("promoter_status"))")
                    fetchedEvent = event as? Event
                }
                
            } else {
                print("no events by id")
                fetchedEvent = nil
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            fetchedEvent = nil
        }
        return fetchedEvent
    }

    /*
    @brief Delete all events and associated objects
    @discussion
    @param None
    @return None
    */
    
    func deleteAllEvents() {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedContext)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try self.managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    self.managedContext.deleteObject(result)
                    print("Event deleted")
                }
                
                try self.managedContext.save()
            }
        } catch {
            print("Failed to delete all events")
        }
    }
    
    /*
    @brief Delete event with specific id
    @discussion
    @param eventId
    @return None
    */
    
    func deleteEvent(eventId: NSNumber) {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedContext)
        
        // Create predicate for filtering events by id
        let pred = NSPredicate(format: "id = %@", eventId)
        fetchRequest.predicate = pred
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.managedContext.executeFetchRequest(fetchRequest)
            
            if (result.count > 0) {
                for event in result {
                    print("Event deleted with id " + eventId.stringValue)
                    self.managedContext.deleteObject(event as! NSManagedObject)
                }
                
            } else {
                print("No events with id " + eventId.stringValue)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
}





