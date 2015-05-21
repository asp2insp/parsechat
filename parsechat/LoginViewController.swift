//
//  ViewController.swift
//  parsechat
//
//  Created by Josiah Gaskin on 5/20/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onButtonaction(sender: UIButton) {
        switch sender {
        case signUp:
            NSLog("Sign Up")
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            user.email = username.text
            
            user.signUpInBackgroundWithBlock({ (success, error) in
                if let err = error {
                    self.showError(err)
                } else {
                     NSLog("Login Success!")
                    self.performSegueWithIdentifier("doLogin", sender: self)
                }
            })
        case signIn:
            NSLog("Sign In")
            PFUser.logInWithUsernameInBackground(username.text, password: password.text, block: { (user, error) -> Void in
                if user != nil {
                    NSLog("Login Success!")
                    self.performSegueWithIdentifier("doLogin", sender: self)
                } else {
                    self.showError(error!)
                }
            })
        default:
            NSLog("Unknown Sender")
        }
    }
    
    func showError(error: NSError) {
        let errorString = error.userInfo?["error"] as? String
        var alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

