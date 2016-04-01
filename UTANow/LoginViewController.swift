//
//  LoginViewController.swift
//  UTANow
//
//  Created by Cameron Moreau on 11/7/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import UIKit
import PKHUD

class LoginViewController: UIViewController {
    
    @IBAction func actionLoginWithFacebook(sender: AnyObject) {
        LoginHelper.loginWithFacebook(self, completion: { user, error in
            if error != nil {
                HUD.flash(.Error, withDelay: 1.0)
            } else {
                HUD.flash(.Success, withDelay: 1.0)
                user!.saveData()
                self.performSegueWithIdentifier("eventListSegue", sender: nil)
            }
        })
    }
    
    @IBAction func actionSkip(sender: AnyObject) {
        performSegueWithIdentifier("eventListSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Update status bar color
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
