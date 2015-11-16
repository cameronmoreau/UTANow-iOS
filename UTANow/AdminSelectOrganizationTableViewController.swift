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

class AdminSelectOrganizationTableViewController: UITableViewController {
    
    @IBAction func btnCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var orgs: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBSDKAccessToken.currentAccessToken()
        //FBSDKAccessToken.setCurrentAccessToken(token: FBSDKAccessToken!)
        
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
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orgs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AdminSelectOrganizationTableViewCell

        let org = orgs[indexPath.row] as! NSDictionary
        
        let imageUrl = org.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String
        
        cell.labelName.text = org["name"] as? String
        cell.imagePicture.kf_setImageWithURL(NSURL(string: imageUrl)!)

        return cell
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
