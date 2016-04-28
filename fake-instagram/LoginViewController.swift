//
//  ViewController.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit
import FLAnimatedImage

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
		loadGIF()
		if let email = emailTextField.text , let password = passwordTextField.text{ DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
			if error == nil {
				NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
				if NSUserDefaults.standardUserDefaults().valueForKey("profileImageURL") != nil {
					let storyboard = UIStoryboard(name: "FeedViews", bundle: nil)
					let vc = storyboard.instantiateViewControllerWithIdentifier("Feed") as! UITabBarController
					self.presentViewController(vc, animated: false, completion: nil)
				}else {
					self .performSegueWithIdentifier("LoggedIn", sender: nil)
				}
			}else{
				let alert = UIAlertController (title: "Error", message: "Invalid e-mail or password, please try again.", preferredStyle: .Alert)
				let returnAction = UIAlertAction(title: "Return", style: .Default, handler: nil)
				alert.addAction(returnAction)
				self.presentViewController(alert, animated: true, completion: nil)
				print(error.description)
			}
			
		})
			
		}
	}
	
	func loadGIF(){
		let imageView = FLAnimatedImageView()
		imageView.animatedImage = GIF
		imageView.frame = self.view.frame
		self.view.addSubview(imageView)
	}
	
}

