//
//  Event.swift
//  UTANow
//
//  Created by Cameron Moreau on 11/7/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import Parse

class Event : PFObject, PFSubclassing {
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Event"
    }
    
    @NSManaged var title: String!
    @NSManaged var imageUrl: String!
    @NSManaged var desc: String!
    @NSManaged var location: [String:AnyObject]!
    @NSManaged var locationGPS: PFGeoPoint!
    @NSManaged var startsAt: NSDate!
    
    func getListingAddress() -> String {
        if let street = location["street"] {
            if let city = location["city"] {
                if let state = location["state"] {
                    return "\(street) \(city), \(state)"
                }
            }
        }
        
        return "No address available"
    }
    
    func getListingStartTime() -> String {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MMMM d, yyyy @ H:mm a"
        return dateFormat.stringFromDate(startsAt)
        
    }
    
    func getLocationGPS() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: locationGPS.latitude, longitude: locationGPS.longitude)
    }
}
