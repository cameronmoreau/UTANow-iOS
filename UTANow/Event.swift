//
//  Event.swift
//  UTANow
//
//  Created by Cameron Moreau on 11/7/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

class Event {
    var title: String?
    var location: String?
    var time: String?
    var imageUrl: String?
    
    init(title: String, location: String, time: String, imageUrl: String) {
        self.title = title
        self.location = location
        self.time = time
        self.imageUrl = imageUrl
    }
}
