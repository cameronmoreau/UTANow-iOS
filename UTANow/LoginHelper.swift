//
//  LoginHelper.swift
//  UTANow
//
//  Created by Cameron Moreau on 2/26/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginHelper {
    
    static let ref = Firebase(url: "https://uta-now.firebaseio.com")
    static let permissions = ["public_profile", "email", "user_friends", "user_birthday"]
    
    static func isLoggedIn() -> Bool {
        return ref.authData != nil
    }
    
    static func logOut() {
        ref.unauth()
    }

    static func loginWithFacebook(vc: UIViewController, completion: ((user: User?, error: NSError?) -> ())) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(permissions, fromViewController: vc, handler: {result, error in
            
            //Check errors
            if error != nil {
                completion(user: nil, error: error)
                return
            } else if result.isCancelled {
                completion(user: nil, error: NSError(domain: "UserAuth", code: 0, userInfo: ["error": "User cancelled request"]))
                return
            }
                
            //Facebook login was successful
            authWithFirebase(result.token.tokenString, completion: completion)
        })
    }
    
    private static func authWithFirebase(token: String, completion: ((user: User?, error: NSError?) -> ())) {
        ref.authWithOAuthProvider("facebook", token: token) { error, authData in
            if error != nil {
                completion(user: nil, error: NSError(domain: "UserAuth", code: 0, userInfo: ["error": "Failed auth with Firebase"]))
                return
            }
                
            //Login was successful
            let data = authData.providerData
            let profileData = data["cachedUserProfile"] as! [String:AnyObject]
            let user = User(authData: authData)
            
            let privateData: [String:AnyObject] = [
                "provider": authData.provider,
                "fbId": data["id"]!,
                "profileImage": user.profileImageUrl!,
                "fbToken": data["accessToken"]!,
                "fbTokenExpires": authData.expires,
                "birthday": profileData["birthday"]!,
                "name": user.name!,
                "gender": profileData["gender"]!,
                "email": user.email!,
            ]
            
            //Store data to Firebase
            ref.childByAppendingPath("userInfo/\(authData.uid)").setValue(privateData)
            ref.childByAppendingPath("users/\(authData.uid)").setValue(user.toDictionary())
            
            //Done
            completion(user: user, error: nil)
        }
    }
    
//    private static func getProfilePicture() {
//        let paramFields = "picture.type(large)"
//        
//        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": paramFields]).startWithCompletionHandler({
//            connection, result, error in
//            
//        })
//    }
    
}