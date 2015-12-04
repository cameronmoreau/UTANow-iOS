//
//  MenuOverlayViewController.swift
//  UTANow
//
//  Created by Cameron Moreau on 12/3/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import UIKit

protocol MenuOverlayDelegate {
    func closePressed()
    func organizationsPressed()
    func createEventPressed()
    func settingsPressed()
}

class MenuOverlayViewController: UIViewController {
    
    var delegate: MenuOverlayDelegate?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var btnOrganizations: UIButton!
    @IBOutlet weak var btnCreateEvent: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    
    @IBAction func closeMenu(sender: AnyObject) {
        delegate?.closePressed()
    }
    
    @IBAction func openOrganizations(sender: AnyObject) {
        delegate?.organizationsPressed()
    }
    
    @IBAction func openCreateEvent(sender: AnyObject) {
        delegate?.createEventPressed()
    }
    
    @IBAction func openSettings(sender: AnyObject) {
        delegate?.settingsPressed()
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
        var start = 0.5
        let interval = 0.35, yOffset = CGFloat(50)
        
        for b in buttons {
            //b.alpha = 0;
            b.center.y -= yOffset
            
            UIView.animateWithDuration(start, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseIn, animations: { b.center.y += yOffset }, completion: nil)
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
