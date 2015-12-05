//
//  AdminSelectOrganizationTableViewController.swift
//  UTANow
//
//  Created by Cameron Moreau on 11/13/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class AdminAddOrganizationTableViewController: UITableViewController {
    
    @IBAction func btnCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var orgs: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paramFields = "picture.type(large), name, about, id, emails"
        
        FBSDKGraphRequest(graphPath: "/me/accounts", parameters: ["fields": paramFields]).startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if error == nil {
                self.orgs = result["data"] as! NSMutableArray
                self.tableView.reloadData()
            } else {
                print(error)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return orgs.count
            
        default:
            return 1
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "Found Organizations"
            
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(indexPath.section) {
        case 0:
            return CGFloat(65)
        default:
            return CGFloat(45)
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Organization cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("organizationCell", forIndexPath: indexPath) as! AdminAddOrganizationTableViewCell
            
            let org = orgs[indexPath.row] as! NSDictionary
            
            let imageUrl = org.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String
            
            cell.labelName.text = org["name"] as? String
            cell.imagePicture.kf_setImageWithURL(NSURL(string: imageUrl)!)
            
            return cell
        }
        
        //Other/ not found
        else {
            return tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        }
    }

}
