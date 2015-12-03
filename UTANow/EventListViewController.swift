//
//  EventListViewController.swift
//  UTANow
//
//  Created by Cameron Moreau on 11/7/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Parse
import ParseFacebookUtilsV4

class EventListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBAction func openMenu(sender: AnyObject) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("MenuOverlayViewController")
        vc.modalPresentationStyle = .OverCurrentContext
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    var refreshControl:UIRefreshControl!
    
    let kSearchPaddingX: CGFloat = 15
    let kSearchPaddingY: CGFloat = 20
    
    let kSearchBarHeight: CGFloat = 44
    
    let kNumFilterButtons: CGFloat = 4
    
    let kFilterButtonHeight: CGFloat = 55
    
    var events: [Event] = []
    let newEvents = []
    
    @IBAction func tempPublishLogin(sender: UIBarButtonItem) {
        let permissions = ["manage_pages"]
        
        PFFacebookUtils.logInInBackgroundWithPublishPermissions(permissions, block: {
            (user, error) -> Void in
            
            if user != nil {
                print("It worked")
            }
        })
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tabBtn1: UIButton!
    @IBOutlet weak var tabBtn2: UIButton!
    @IBOutlet weak var tabBtn3: UIButton!
    
    var searchBar: UIView!
    var searchButton: UIButton!
    var searchField: UITextField!
    
    var filterMenu: UIView!
    
    var noResultsLabel: UILabel!
    
    var searchBarCreated = false
    
    var searchBarExpanded = false
    var filterMenuExpanded = false
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //change nav bar title font
        //TODO: pretty-up the navbar title
        //navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Woah", size: 35)!]
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        //Query for parse events
        refresh(nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if searchBarCreated == false {
            createSearchBar()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Pull to refresh
    func refresh(sender: AnyObject?) {
        let query = PFQuery(className: "Event")
        query.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.events = objects as! [Event]
                self.tableView.reloadData()
            }
            
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    //MARK: - IBActions
    
    @IBAction func tabButtonTapped(sender: UIButton) {
        sender.tintColor = UIColor(red: 245/255.0, green: 128/255.0, blue: 37/255.0, alpha: 1.0)
        
        if sender == tabBtn1 {
            tabBtn2.tintColor = UIColor(red: 91/255.0, green: 92/255.0, blue: 89/255.0, alpha: 1.0)
            tabBtn3.tintColor = UIColor(red: 91/255.0, green: 92/255.0, blue: 89/255.0, alpha: 1.0)
            
            //TODO: implement lightning tab button action
        }
        
        if sender == tabBtn2 {
            tabBtn1.tintColor = UIColor(red: 91/255.0, green: 92/255.0, blue: 89/255.0, alpha: 1.0)
            tabBtn3.tintColor = UIColor(red: 91/255.0, green: 92/255.0, blue: 89/255.0, alpha: 1.0)
            
            //TODO: implement refresh tab button action
        }
        
        if sender == tabBtn3 {
            tabBtn1.tintColor = UIColor(red: 91/255.0, green: 92/255.0, blue: 89/255.0, alpha: 1.0)
            tabBtn2.tintColor = UIColor(red: 91/255.0, green: 92/255.0, blue: 89/255.0, alpha: 1.0)
            
            //TODO: implement thumbs up tab button action
        }
    }
    
    //MARK: - Search bar
    
    func createSearchBar() {
        let container = UIView(frame: CGRectMake(kSearchPaddingX, kSearchPaddingY, UIScreen.mainScreen().bounds.size.width-kSearchPaddingX*2, kSearchBarHeight))
        
        searchBar = UIView(frame: CGRectMake(0, 0, container.frame.size.width, kSearchBarHeight))
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 4
        searchBar.backgroundColor = UIColor.whiteColor()
        searchBar.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).CGColor
        searchBar.layer.borderWidth = 0.5
        container.addSubview(searchBar)
        
        searchButton = UIButton(type: .System)
        searchButton.frame = CGRectMake(0, 0, kSearchBarHeight, kSearchBarHeight)
        searchButton.backgroundColor = UIColor.whiteColor()
        searchButton.layer.cornerRadius = searchButton.frame.size.width/2
        searchButton.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).CGColor
        //TODO: add search bar icon
        searchButton.setImage(UIImage(named: ""), forState: .Normal)
        searchButton.addTarget(self, action: Selector("searchButtonTapped:"), forControlEvents: .TouchUpInside)
        searchBar.addSubview(searchButton)
        
        let filterBtn = UIButton(type: .System)
        filterBtn.frame = CGRectMake(searchBar.frame.size.width-70, 0, 70, kSearchBarHeight)
        filterBtn.backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
        filterBtn.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 12)
        filterBtn.setTitle("Filter", forState: .Normal)
        filterBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        filterBtn.addTarget(self, action: Selector("filterButtonTapped:"), forControlEvents: .TouchUpInside)
        searchBar.addSubview(filterBtn)
        
        searchField = UITextField()
        searchField.borderStyle = .None
        searchField.frame = CGRectMake(searchButton.frame.size.width, 0, searchBar.frame.size.width-searchButton.frame.size.width-filterBtn.frame.size.width, kSearchBarHeight)
        searchField.returnKeyType = .Done
        searchField.backgroundColor = UIColor.whiteColor()
        searchField.font = UIFont(name: "AvenirNext-Regular", size: 13)
        searchField.clearButtonMode = .WhileEditing
        searchField.placeholder = "Search for an event!"
        searchField.delegate = self
        searchField.addTarget(self, action:"searchTextChanged:", forControlEvents:.EditingChanged)
        searchBar.addSubview(searchField)
        
        filterMenu = UIView(frame: CGRectMake(0, 0, searchBar.frame.size.width, 0))
        filterMenu.backgroundColor = UIColor.whiteColor()
        filterMenu.clipsToBounds = true
        filterMenu.layer.cornerRadius = 4
        filterMenu.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).CGColor
        filterMenu.layer.borderWidth = 0.5
        container.insertSubview(filterMenu, belowSubview: searchBar)
        
        let dateBtn = UIButton(type: .System)
        dateBtn.frame = CGRectMake(14, kSearchBarHeight+14, (filterMenu.frame.size.width-14*5)/kNumFilterButtons, kFilterButtonHeight) //14 because odd number padding doesn't divide equally
        dateBtn.layer.cornerRadius = 4
        dateBtn.backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
        dateBtn.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 12)
        dateBtn.setTitle("Date", forState: .Normal)
        dateBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //TODO: dateBtnTapped implementation
        //dateBtn.addTarget(self, action: <#T##Selector#>, forControlEvents: .TouchUpInside)
        filterMenu.addSubview(dateBtn)
        
        let sportsBtn = UIButton(type: .System)
        sportsBtn.frame = CGRectMake(14+dateBtn.frame.size.width+14, dateBtn.frame.origin.y, dateBtn.frame.size.width, kFilterButtonHeight)
        sportsBtn.layer.cornerRadius = 4
        sportsBtn.backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
        sportsBtn.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 12)
        sportsBtn.setTitle("Sports", forState: .Normal)
        sportsBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //TODO: sportsBtnTapped implementation
        //sportsBtn.addTarget(self, action: <#T##Selector#>, forControlEvents: .TouchUpInside)
        filterMenu.addSubview(sportsBtn)
        
        let distanceBtn = UIButton(type: .System)
        distanceBtn.frame = CGRectMake(14+dateBtn.frame.size.width+14+sportsBtn.frame.size.width+14, dateBtn.frame.origin.y, dateBtn.frame.size.width, kFilterButtonHeight)
        distanceBtn.layer.cornerRadius = 4
        distanceBtn.backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
        distanceBtn.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 12)
        distanceBtn.setTitle("Distance", forState: .Normal)
        distanceBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //TODO: distanceBtnTapped implementation
        //distanceBtn.addTarget(self, action: <#T##Selector#>, forControlEvents: .TouchUpInside)
        filterMenu.addSubview(distanceBtn)
        
        let foodBtn = UIButton(type: .System)
        foodBtn.frame = CGRectMake(14+dateBtn.frame.size.width+14+sportsBtn.frame.size.width+14+distanceBtn.frame.size.width+14, dateBtn.frame.origin.y, dateBtn.frame.size.width, kFilterButtonHeight)
        foodBtn.layer.cornerRadius = 4
        foodBtn.backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
        foodBtn.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 12)
        foodBtn.setTitle("Food", forState: .Normal)
        foodBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //TODO: foodBtnTapped implementation
        //foodBtn.addTarget(self, action: <#T##Selector#>, forControlEvents: .TouchUpInside)
        filterMenu.addSubview(foodBtn)
        
        self.view.addSubview(container)
        
        searchBar.frame = CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, searchButton.frame.size.width, searchBar.frame.size.height) //hide initially
        searchBar.superview?.frame = CGRectMake(kSearchPaddingX, kSearchPaddingY, searchBar.frame.size.width, searchBar.frame.size.height)
        
        searchBarCreated = true
        
        //set up no results label
        noResultsLabel = UILabel(frame: CGRectMake(kSearchPaddingX, 0, UIScreen.mainScreen().bounds.size.width-kSearchPaddingX*2, 150))
        noResultsLabel.center = CGPointMake(self.view.center.x, self.view.center.y - (navigationController?.navigationBar.frame.size.height)! - UIApplication.sharedApplication().statusBarFrame.size.height - 150/2)
        noResultsLabel.numberOfLines = 0
        noResultsLabel.hidden = true
        noResultsLabel.backgroundColor = UIColor.clearColor()
        noResultsLabel.lineBreakMode = .ByWordWrapping
        noResultsLabel.textAlignment = .Center
        noResultsLabel.textColor = UIColor.lightGrayColor()
        noResultsLabel.text = "No results"
        noResultsLabel.font = UIFont(name: "AvenirNext-Medium", size: 18)
        
        self.view.addSubview(noResultsLabel)
    }
    
    func searchButtonTapped(sender: UIButton) {
        if let searchText = self.searchField?.text {
            if self.filterEventsForSearchText(searchText).count != 0 {
                expandSearchBar()
            }
        }
    }
    
    func filterButtonTapped(sender: UIButton) {
        expandFilterMenu(false)
    }
    
    @IBAction func expandSearchBar() {
        searchBarExpanded = !searchBarExpanded
        
        if filterMenuExpanded {
            expandFilterMenu(true)
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if self.searchBarExpanded {
                    self.searchBar.layer.borderWidth = 0.5
                    self.searchButton.layer.borderWidth = 0
                    
                    self.searchButton.layer.cornerRadius = 0
                    
                    self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, UIScreen.mainScreen().bounds.size.width-self.kSearchPaddingX*2, self.searchBar.frame.size.height)
                    self.searchBar.superview?.frame = CGRectMake(self.kSearchPaddingX, self.kSearchPaddingY, self.searchBar.frame.size.width, self.searchBar.frame.size.height)
                } else {
                    self.searchBar.layer.borderWidth = 0
                            
                    self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, self.searchButton.frame.size.width, self.searchBar.frame.size.height)
                    self.searchBar.superview?.frame = CGRectMake(self.kSearchPaddingX, self.kSearchPaddingY, self.searchBar.frame.size.width, self.searchBar.frame.size.height)
                            
                    self.searchField.resignFirstResponder()
                }
                }) { (finished: Bool) -> Void in
                    if self.searchBarExpanded {
                        self.searchBar.backgroundColor = UIColor.whiteColor()
                        self.searchButton.layer.borderWidth = 0
                    } else {
                        self.searchBar.backgroundColor = UIColor.clearColor()
                        self.searchButton.layer.borderWidth = 0.5
                        self.searchButton.layer.cornerRadius = 4
                    }
            }
        }
    }

    @IBAction func expandFilterMenu(collapseSearchBarToo: Bool) {
        filterMenuExpanded = !filterMenuExpanded
        
        let animationDuration = 0.3
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            if self.filterMenuExpanded {
                self.searchBar.layer.borderWidth = 0
                self.filterMenu.frame = CGRectMake(self.filterMenu.frame.origin.x, self.filterMenu.frame.origin.y, self.filterMenu.frame.size.width, self.searchBar.frame.size.height+83)
                self.filterMenu.superview?.frame = CGRectMake(self.kSearchPaddingX, self.kSearchPaddingY, self.filterMenu.frame.size.width, self.filterMenu.frame.size.height)
            } else {
                self.filterMenu.frame = CGRectMake(self.filterMenu.frame.origin.x, self.filterMenu.frame.origin.y, self.filterMenu.frame.size.width, 0)
                self.filterMenu.superview?.frame = CGRectMake(self.kSearchPaddingX, self.kSearchPaddingY, self.filterMenu.frame.size.width, self.searchBar.frame.size.height)
            }
            }) { (finished: Bool) -> Void in
                if !self.filterMenuExpanded {
                    self.searchBar.layer.borderWidth = 0.5
                }
        }
        
        if collapseSearchBarToo {
            if let searchText = self.searchField?.text {
                if filterEventsForSearchText(searchText).count != 0 {
                    UIView.animateWithDuration(animationDuration, delay: animationDuration, options: .AllowAnimatedContent, animations: { () -> Void in
                            self.searchBar.layer.borderWidth = 0
                            
                            self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, self.searchButton.frame.size.width, self.searchBar.frame.size.height)
                            self.searchBar.superview?.frame = CGRectMake(self.kSearchPaddingX, self.kSearchPaddingY, self.searchBar.frame.size.width, self.searchBar.frame.size.height)
                            
                            self.searchField.resignFirstResponder()
                        }) { (finished: Bool) -> Void in
                            self.searchBar.backgroundColor = UIColor.clearColor()
                            self.searchButton.layer.borderWidth = 0.5
                            self.searchButton.layer.cornerRadius = 4
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let searchText = searchField?.text {
            if filterEventsForSearchText(searchText).count != 0 {
                //collapse search bar when scrolling
                let animationDuration = 0.2
                var delay = 0.0
                
                if filterMenuExpanded {
                    delay = animationDuration
                }
                
                UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                    self.filterMenu.frame = CGRectMake(self.filterMenu.frame.origin.x, self.filterMenu.frame.origin.y, self.filterMenu.frame.size.width, 0)
                    self.filterMenu.superview?.frame = CGRectMake(self.kSearchPaddingX, self.kSearchPaddingY, self.filterMenu.frame.size.width, self.searchBar.frame.size.height)
                    }, completion: { (finished: Bool) -> Void in
                        self.searchBar.layer.borderWidth = 0.5
                        
                        self.filterMenuExpanded = false
                })
                
                UIView.animateWithDuration(animationDuration, delay: delay, options: .AllowAnimatedContent, animations: { () -> Void in
                    self.searchBar.layer.borderWidth = 0
                    
                    self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, self.searchButton.frame.size.width, self.searchBar.frame.size.height)
                    self.searchBar.superview?.frame = CGRectMake(self.kSearchPaddingX, self.kSearchPaddingY, self.searchBar.frame.size.width, self.searchBar.frame.size.height)
                    
                    self.searchField.resignFirstResponder()
                    }) { (finished: Bool) -> Void in
                        self.searchBar.backgroundColor = UIColor.clearColor()
                        self.searchButton.layer.borderWidth = 0.5
                        self.searchButton.layer.cornerRadius = 4
                        
                        self.searchBarExpanded = false
                }
            }
        }
    }
    
    //MARK: - Text field
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let searchText = searchField?.text {
            if filterEventsForSearchText(searchText).count != 0 {
                textField.resignFirstResponder()
            }
        }
        
        return true
    }
    
    func searchTextChanged(sender: UITextField) {
        tableView.reloadData()
        
        if filterEventsForSearchText(sender.text!).count == 0 {
            //no results
            noResultsLabel.hidden = false
        } else {
            noResultsLabel.hidden = true
        }
    }
    
    func filterEventsForSearchText(searchText: String) -> [Event] {
        if searchText.characters.count > 0 {
            return events.filter({(event: Event) -> Bool in
                return event.title?.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
            })
        } else {
            return events
        }
    }

    //MARK: - Table view

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchText = searchField?.text {
            return filterEventsForSearchText(searchText).count
        } else {
            return events.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EventListTableViewCell
        
        var correctArray: [Event]!
        if let searchText = searchField?.text {
            correctArray = filterEventsForSearchText(searchText)
        } else {
            correctArray = events
        }
        
        //Give event object to the cell
        cell.setData(correctArray[indexPath.row])
        cell.setData(events[indexPath.row])
        
        cell.btnOpenMap.tag = indexPath.row;
        cell.btnOpenMap.addTarget(self, action: "openMapView:", forControlEvents: .TouchUpInside)
        
        cell.btnQuickAdd.tag = indexPath.row;
        cell.btnQuickAdd.addTarget(self, action: "quickAdd:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 185
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEventSegue" {
            let tvc = segue.destinationViewController as! EventViewController
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil) //gets rid of text after chevron
            if tableView.indexPathForSelectedRow?.row != nil {
                tvc.event = events[tableView.indexPathForSelectedRow!.row]
            }
        }
        
        else if segue.identifier == "mapSegue" {
            let mapVC = (segue.destinationViewController as! UINavigationController).topViewController as! MapViewController
            let selectedEvent = events[sender!.tag]
            mapVC.markerPoint = selectedEvent.getLocationGPS()
            mapVC.markerTitle = selectedEvent.title
        }
    }
    
    
    // MARK: - EventCell Clickable Items
    func openMapView(sender: UIButton) {
        self.performSegueWithIdentifier("mapSegue", sender: sender)
    }
    
    func quickAdd(sender: UIButton) {
    }
}
