//
//  User.swift
//  UTANow
//
//  Created by Cameron Moreau on 2/26/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import Firebase

class User : NSObject {
    
    static let sharedInstance = User()
    
    var uid: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    
    override init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        self.uid = defaults.valueForKey("userId") as? String
        self.name = defaults.valueForKey("userName") as? String
        self.email = defaults.valueForKey("userEmail") as? String
        self.profileImageUrl = defaults.valueForKey("userProfileImageUrl") as? String
    }
    
    init(snapshot: FDataSnapshot) {
        self.uid = snapshot.key
        self.name = snapshot.value["name"] as? String
        self.email = snapshot.value["email"] as? String
        self.profileImageUrl = snapshot.value["profileImageUrl"] as? String
    }
    
    init(authData: FAuthData) {
        let provider = authData.providerData
        
        self.uid = authData.uid
        self.name = provider["displayName"] as? String
        self.email = provider["email"] as? String
        self.profileImageUrl = provider["profileImageURL"] as? String
    }
    
    func saveData() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(uid, forKey: "userId")
        defaults.setValue(name, forKey: "userName")
        defaults.setValue(email, forKey: "userEmail")
        defaults.setValue(profileImageUrl, forKey: "userProfileImageUrl")
        defaults.synchronize()
    }
    
    func toDictionary() -> [String:AnyObject] {
        return [
            "name": name!,
            "email": email!,
            "profileImageUrl": profileImageUrl!
        ]
    }
    
}
