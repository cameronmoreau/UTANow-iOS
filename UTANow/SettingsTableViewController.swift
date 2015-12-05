//
//  SettingsTableViewController.swift
//  UTANow
//
//  Created by Cameron Moreau on 12/5/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logoutSegue" {
            PFUser.logOutInBackground()
            
            //TODO: Clear saved userdefaults for that login
        }
    }
}
