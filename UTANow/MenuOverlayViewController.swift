//
//  MenuOverlayViewController.swift
//  UTANow
//
//  Created by Cameron Moreau on 12/3/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import UIKit

class MenuOverlayViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var btnOrganizations: UIButton!
    @IBOutlet weak var btnCreateEvent: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    
    @IBAction func closeMenu(sender: AnyObject) {
        //This is bad and needs to be removed
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func openOrganizations(sender: AnyObject) {
    }
    
    @IBAction func openCreateEvent(sender: AnyObject) {
    }
    
    @IBAction func openSettings(sender: AnyObject) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.opaque = false
        
        //Load profile image
        let imageUrl = NSUserDefaults.standardUserDefaults().objectForKey("ProfileImageUrl") as? String
        
        if imageUrl != nil {
            image.kf_setImageWithURL(NSURL(string: imageUrl!)!)
        } else {
            image.kf_setImageWithURL(NSURL(string: "http://mypetforumonline.com/wp-content/uploads/2014/09/8055895_orig.jpg")!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        setupAnimations([btnOrganizations, btnCreateEvent, btnSettings])
    }
    
    func setupAnimations(buttons: [UIButton]) {
        var start = 0.5, interval = 0.35
        
        for b in buttons {
            b.alpha = 0;
            UIView.animateWithDuration(start, animations: { b.alpha = 1} )
            start += interval
        }
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
