//
//  Comment.swift
//  UTANow
//
//  Created by Cameron Moreau on 2/26/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import Firebase

class Comment : NSObject {
    
    var id: String?
    var text: String!
    var user: User?
    
    init(snapshot: FDataSnapshot) {
        self.id = snapshot.key
        self.text = snapshot.value["text"] as! String
    }
    
    init(user: User, text: String) {
        self.user = user
        self.text = text
    }
    
    func toFirebase() -> [String:AnyObject] {
        return [
            "text": self.text,
            "user": user!.uid!
        ]
    }
    
}