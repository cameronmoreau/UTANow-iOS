//
//  CommentsViewController.swift
//  UTANow
//
//  Created by Cameron Moreau on 2/26/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userText: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func btnSendPressed(sender: UIButton) {
        addComment()
    }
    
    @IBAction func btnClosePressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var comments = [Comment]()
    var event: Event?
    
    var commentsRef: Firebase!
    var usersRef: Firebase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        usersRef = Firebase(url:"https://uta-now.firebaseio.com/users")
        commentsRef = Firebase(url:"https://uta-now.firebaseio.com/comments/\(event!.id!)")
        commentsRef!.observeEventType(.ChildAdded, withBlock: { snapshot in
            
            let comment = Comment(snapshot: snapshot)
            let userId = snapshot.value["user"] as! String
           
            
            self.usersRef.childByAppendingPath(userId).observeSingleEventOfType(.Value, withBlock: {
                snap in
                
                comment.user = User(snapshot: snap)
                self.comments.append(comment)
                self.tableView.reloadData()
            })
            
//            let comment = Comment(snapshot: snapshot)
//            self.comments.append(comment)
//            self.tableView.reloadData()
        })
        
        
        //Fix keyboard issue
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func addComment() {
        if let text = userText.text {
            let user = User.sharedInstance
            let comment = Comment(user: user, text: text)
            userText.text = ""
            
            
            commentsRef!.childByAutoId().setValue(comment.toFirebase())
        }
    }
    

    //MARK: - Keyboard Fix
    func keyboardShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(info[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
        })
    }
    
    func keyboardHide(notification: NSNotification) {
        let info = notification.userInfo!
        UIView.animateWithDuration(info[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval, animations: { () -> Void in
            self.bottomConstraint.constant = 0
        })
    }
    
    //MARK: - TableView Functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 83
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CommentTableViewCell
        
        cell.bind(self.comments[indexPath.row])
        
        return cell
    }
}
