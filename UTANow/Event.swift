//
//  Event.swift
//  UTANow
//
//  Created by Cameron Moreau on 11/7/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class Event : NSObject {
    
    var id: String?
    var title: String!
    var imageUrl: String!
    var desc: String!
    var location: [String:AnyObject]!
    var locationCoords: CLLocationCoordinate2D!
    var startsAt: NSDate!
    
    init(snapshot: FDataSnapshot) {
        self.id = snapshot.key
        self.title = snapshot.value["title"] as? String
        self.imageUrl = snapshot.value["imgUrl"] as? String
        self.desc = snapshot.value["description"] as? String
        self.locationCoords = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.startsAt = NSDate()
        self.location = ["test": "test"]
    }
    
    func getListingAddress() -> String {
//        if let street = location["address"] {
//            if let city = location["city"] {
//                if let state = location["state"] {
//                    return "\(street) \(city), \(state)"
//                }
//            }
//        }
        
        return "No address available"
    }
    
    func getListingStartTime() -> String {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MMMM d, yyyy @ H:mm a"
        return dateFormat.stringFromDate(startsAt)
    }
}
