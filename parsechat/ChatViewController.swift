//
//  ChatViewController.swift
//  parsechat
//
//  Created by Josiah Gaskin on 5/20/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import Foundation


class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sendMessage(sender: AnyObject) {
        var messageObj = PFObject(className: "Message")
        messageObj["text"] = messageText.text
        messageObj["user"] = PFUser.currentUser()
        messageObj.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                NSLog("Saved Message")
                self.messageText.text = ""
            } else {
                NSLog("Message Failed: \(error?.localizedDescription)")
            }
        }
    }
    
}

