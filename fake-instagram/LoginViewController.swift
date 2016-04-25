//
//  ViewController.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()
		let currentUserId = NSUserDefaults.standardUserDefaults().valueForKey("uid")as? String
        if currentUserId != nil{
         if DataService.dataService.USER_REF.childByAppendingPath(currentUserId).authData != nil {
                
                self.performSegueWithIdentifier("LoggedIn", sender: nil)
            }
        }
	}
    @IBAction func OnLoginButtonPress(sender: UIButton) {
        if let email = emailTextField.text , let password = passwordTextField.text{ DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
            if error == nil {
                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                self .performSegueWithIdentifier("LoggedIn", sender: nil)
            }else{
                let alert = UIAlertController (title: "Error", message: "Invalid e-mail or login, please try again.", preferredStyle: .Alert)
                let returnAction = UIAlertAction(title: "Return", style: .Default, handler: nil)
                alert.addAction(returnAction)
                self.presentViewController(alert, animated: true, completion: nil)
                print(error.description)
            }
            
        })
            
        }
    }
}
//alert view controller if error
