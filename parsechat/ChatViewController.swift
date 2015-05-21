//
//  ChatViewController.swift
//  parsechat
//
//  Created by Josiah Gaskin on 5/20/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import Foundation


class ChatViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageText: UITextField!
    
    var messages : [PFObject] = []
    
    var refreshControl : UIRefreshControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "refresh:", userInfo: nil, repeats: true)
        refresh(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender: AnyObject) {
        var query = PFQuery(className:"Message")
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.messages = objects
                }
            } else {
                NSLog("Could not retrieve messages")
            }
        }
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("message") as! MessageCell
        cell.messageText.text = self.messages[indexPath.row]["text"] as? String ?? "No Message"
        cell.username.text = self.messages[indexPath.row]["user"]?["username"] as? String ?? "No User"
        return cell
    }

    @IBAction func sendMessage(sender: AnyObject) {
        var messageObj = PFObject(className: "Message")
        messageObj["text"] = messageText.text
        messageObj["user"] = PFUser.currentUser()
        messageObj.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                NSLog("Saved Message")
                self.messageText.text = ""
                self.refresh(self)
            } else {
                NSLog("Message Failed: \(error?.localizedDescription)")
            }
        }
    }
    
}


class MessageCell : UITableViewCell {
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var username: UILabel!
    
}