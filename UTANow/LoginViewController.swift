//
//  LoginViewController.swift
//  UTANow
//
//  Created by Cameron Moreau on 11/7/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            print("Logged in")
        } else {
            print("Logged out")
        }

        let fbLoginBtn = FBSDKLoginButton()
        fbLoginBtn.center = self.view.center
        //fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends", "user_birthday", "manage_pages", "rsvp_event"]
        fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends"]
        fbLoginBtn.delegate = self
        
        self.view.addSubview(fbLoginBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil {
            print("Successful login")
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
