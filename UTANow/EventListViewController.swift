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
    
    let events = [
        Event(title: "UT Arlington vs. Houston Baptist", location: "600 S. Center St. Arlington, Texas  ", time: "Friday October 16th, 2015 @ 7:00PM", imageUrl: "http://alcalde.texasexes.org/wp-content/uploads/2011/12/13-gamer2011-12-7_UTA_Basketball_Jorge.Corona549.jpg"),
        Event(title: "(50% OFF) PIE FIVE PIZZA", location: "501 Spaniolo Dr. Arlington, Texas ", time: "Monday October 19th, 2015 @ 8:00PM", imageUrl: "http://www.roffinis.com/wp-content/uploads/2011/11/menu12.jpg")
    ]
    
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
    
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var filterMenu: UIView!
    
    let kNoResultsLabelTag = 3852929
    
    var searchBarExpanded = true
    var filterMenuExpanded = false
    
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //change nav bar title font
        //navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Woah", size: 35)!]
        
        searchField.addTarget(self, action:"searchTextChanged:", forControlEvents:.EditingChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        firstLoad = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        filterMenu.frame = CGRectMake(filterMenu.frame.origin.x, filterMenu.frame.origin.y, filterMenu.frame.size.width, 0) //contract filterMenu on first load
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let searchText = searchField?.text {
            if filterEventsForSearchText(searchText).count != 0 && !firstLoad {
                textField.resignFirstResponder()
            }
        }
        
        return true
    }
    
    func filterButtonTapped(sender: UIButton) {
        expandFilterMenu()
    }
    
    @IBAction func expandSearchBar() {
        searchBarExpanded = !searchBarExpanded
        
        UIView.beginAnimations(nil, context: nil)
        if searchBarExpanded {
            searchBarContainer.layer.borderWidth = 0.5
            searchButton.layer.borderWidth = 0
            
            searchBarContainer.backgroundColor = UIColor.whiteColor()
            
            searchBarContainer.frame = CGRectMake(searchBarContainer.frame.origin.x, searchBarContainer.frame.origin.y, searchBar.frame.size.width, searchBarContainer.frame.size.height)
            searchField.frame = CGRectMake(searchField.frame.origin.x, searchField.frame.origin.y, searchBar.frame.size.width-searchButton.frame.size.width-filterButton.frame.size.width, searchField.frame.size.height)
        } else {
            if let searchText = searchField?.text {
                if filterEventsForSearchText(searchText).count != 0 && !firstLoad {
                    searchBarContainer.layer.borderWidth = 0
                    searchButton.layer.borderWidth = 0.5
                    
                    searchBarContainer.backgroundColor = UIColor.clearColor()
                    
                    searchBarContainer.frame = CGRectMake(searchBarContainer.frame.origin.x, searchBarContainer.frame.origin.y, searchBar.frame.size.height, searchBarContainer.frame.size.height)
                    searchField.frame = CGRectMake(searchField.frame.origin.x, searchField.frame.origin.y, 0, searchField.frame.size.height)
                    
                    searchField.resignFirstResponder()
                    
                    if filterMenuExpanded {
                        expandFilterMenu()
                    }
                }
            }
        }
        UIView.commitAnimations()
    }

    @IBAction func expandFilterMenu() {
        filterMenuExpanded = !filterMenuExpanded
        
        UIView.beginAnimations(nil, context: nil)
        if filterMenuExpanded {
            filterMenu.frame = CGRectMake(filterMenu.frame.origin.x, filterMenu.frame.origin.y, filterMenu.frame.size.width, searchBar.frame.size.height+83)
        } else {
            filterMenu.frame = CGRectMake(filterMenu.frame.origin.x, filterMenu.frame.origin.y, filterMenu.frame.size.width, 0)
        }
        UIView.commitAnimations()
    }
    
    func searchTextChanged(sender: UITextField) {
        tableView.reloadData()
        
        if filterEventsForSearchText(sender.text!).count == 0 {
            //no results
            let kPadding: CGFloat = 15
            let noResultsLabel = UILabel(frame: CGRectMake(kPadding, 0, UIScreen.mainScreen().bounds.size.width-kPadding*2, 150))
            noResultsLabel.center = CGPointMake(self.view.center.x, self.view.center.y - (navigationController?.navigationBar.frame.size.height)! - UIApplication.sharedApplication().statusBarFrame.size.height)
            noResultsLabel.numberOfLines = 0
            noResultsLabel.backgroundColor = UIColor.clearColor()
            noResultsLabel.lineBreakMode = .ByWordWrapping
            noResultsLabel.textAlignment = .Center
            noResultsLabel.textColor = UIColor.lightGrayColor()
            noResultsLabel.text = "No results"
            noResultsLabel.tag = kNoResultsLabelTag
            noResultsLabel.font = UIFont(name: "AvenirNext-Medium", size: 18)
            
            if self.view.viewWithTag(kNoResultsLabelTag) == nil {
                self.view.addSubview(noResultsLabel)
            }
        } else {
            if let noResultsLabel = self.view.viewWithTag(kNoResultsLabelTag) {
                noResultsLabel.removeFromSuperview()
            }
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /*if let searchText = searchField?.text {
            if filterEventsForSearchText(searchText).count != 0 && !firstLoad {
                //collapse search bar when scrolling
                UIView.beginAnimations(nil, context: nil)
                searchBarExpanded = false
                
                searchBarContainer.layer.borderWidth = 0
                
                searchBarContainer.backgroundColor = UIColor.clearColor()
                
                searchBarContainer.frame = CGRectMake(searchBarContainer.frame.origin.x, searchBarContainer.frame.origin.y, searchBar.frame.size.height, searchBarContainer.frame.size.height)
                searchField.frame = CGRectMake(searchField.frame.origin.x, searchField.frame.origin.y, 0, searchField.frame.size.height)
                UIView.commitAnimations()
                
                searchField?.resignFirstResponder()
                
                if filterMenuExpanded {
                    expandFilterMenu()
                }
            }
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchText = searchField.text {
            return filterEventsForSearchText(searchText).count
        } else {
            return events.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EventListTableViewCell
        
        var correctArray: [Event]!
        if let searchText = searchField.text {
            correctArray = filterEventsForSearchText(searchText)
        } else {
            correctArray = events
        }
        
        //Give event object to the cell
        cell.setEvent(correctArray[indexPath.row])

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showEvent" {
            let tvc = segue.destinationViewController as! EventViewController
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil) //gets rid of text after chevron
            if tableView.indexPathForSelectedRow?.row != nil {
                tvc.event = events[tableView.indexPathForSelectedRow!.row]
            }
        }
    }

}
