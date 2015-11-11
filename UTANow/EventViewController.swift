//
//  EventTableViewController.swift
//  UTANow
//
//  Created by Andrew Whitehead on 11/10/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import UIKit
import Kingfisher

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerImgView: UIImageView!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    var event: Event?
    
    var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureView()
        
        //set profile picture image
        //profilePicture.image =
        profilePicture.image = UIImage(named: "bg_login") //placeholder
        
        //UTA Now logo
        let navBarTitleLabel = UILabel(frame: CGRectMake(0, 13, 32, 32))
        navBarTitleLabel.text = "UTA"
        navBarTitleLabel.font = UIFont(name: "Woah", size: 35)
        navBarTitleLabel.textColor = UIColor.whiteColor()
        navigationItem.titleView = navBarTitleLabel
        
        //This solution isn't good because the title text seems too far up
        //self.title = "UTA"
        //navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Woah", size: 35)!]
        
        //for light content status bar
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        setNeedsStatusBarAppearanceUpdate()
        
        //to make navigation bar invisible
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        navigationController?.view.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //this returns the navigation bar back to normal after going to "EventTableViewController"
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.backgroundColor = nil
        navigationController?.view.backgroundColor = nil
        navigationController?.navigationBar.barStyle = .Default
        navigationController?.navigationBar.tintColor = nil
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func configureView() {
        if let e = event {
            dateLbl.text = e.time
            titleLbl.text = e.title
            locationLbl.text = e.location
            
            //set header image
            if let url = e.imageUrl {
                headerImgView.kf_setImageWithURL(NSURL(string: url)!)
            }
        }
    }
    
    @IBAction func goingTapped() {
        
    }
    
    //MARK: TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //replace with desired number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //replace with desired number of rows
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        return cell
    }
    
}

public extension UIView {
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable public var borderColor: UIColor {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.CGColor
        }
    }
    
}
