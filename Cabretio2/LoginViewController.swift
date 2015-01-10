//
//  LoginViewController.swift
//  Cabretio2
//
//  Created by Gavin Dinubilo on 12/15/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let transitionManager = TransitionManager()
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    override func viewDidLoad() {
        if (appDelegate.userEmail !== "") {
            self.performSegueWithIdentifier("goToLoginPage", sender: self)
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        if (appDelegate.userEmail !== "") {
            self.performSegueWithIdentifier("goToLoginPage", sender: self)
        }
    }
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let localOrWeb = appDelegate.url
        var urlPath: String = "\(localOrWeb)/api/users/new"
        userEmailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        Alamofire.request(.GET, urlPath, parameters: ["user": ["email":userEmailField.text, "password":passwordField.text], "key": "TESTAPIKEYFORTESTPURPOSES"])
            .responseString {(request, response, data, error) in
                println("Finished Connection")
                println(data!)
                
                if (data! == "no") {
                    let alertview = SCLAlertView().showError("Error", subTitle: "Email or Password Incorrect")
                } else if (data! == "ok") {
                    var userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(self.userEmailField.text, forKey: "email")
                    //                    self.performSegueWithIdentifier("goToLoginPage", sender: self)
                    self.appDelegate.userEmail = self.userEmailField.text
                    self.dismissViewControllerAnimated(false, completion: {
                        let alertview = SCLAlertView().showSuccess("Hooray", subTitle: "You Logged In!")
                    })
                }
                
        }
        
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        let localOrWeb = appDelegate.url
        var urlPath: String = "\(localOrWeb)/api/users/login?email=\(userEmailField.text)&password=\(passwordField.text)&key=TESTAPIKEYFORTESTPURPOSES"
        userEmailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        Alamofire.request(.GET, urlPath)
            .responseString {(request, response, data, error) in
                println("Finished Connection")
                println(data!)
                
                if (data! == "no") {
                    let alertview = SCLAlertView().showError("Error", subTitle: "Email or Password Incorrect")
                } else if (data! == "ok") {
                    var userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(self.userEmailField.text, forKey: "email")
//                    self.performSegueWithIdentifier("goToLoginPage", sender: self)
                    self.appDelegate.userEmail = self.userEmailField.text
                    self.dismissViewControllerAnimated(false, completion: {
                        let alertview = SCLAlertView().showSuccess("Hooray", subTitle: "You Logged In!")
                    })
                }
                
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destinationViewController as UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
        
    }
    
}