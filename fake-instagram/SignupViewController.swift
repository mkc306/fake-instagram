//
//  SignupViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 4/22/16.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit
import Firebase
import FLAnimatedImage

class SignupViewController: UIViewController {
	
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		// Do any additional setup after loading the view.
	}
	
	@IBAction func onRegisterButtonPress(sender: UIButton) {
		loadGIF()
		if let email = emailTextField.text,let password = passwordTextField.text,let username = usernameTextField.text{
			
			let rootReference = DataService.dataService.BASE_REF
			rootReference.createUser(email, password: password, withValueCompletionBlock: {(error,result) -> Void in
				if error == nil{
					let uid = result["uid"] as? String
					let userDict = ["email": email, "username":username]
					let currentUser = DataService.dataService.USER_REF.childByAppendingPath(uid)
					currentUser.setValue(userDict)
					NSUserDefaults.standardUserDefaults().setValue(uid, forKey: "uid")
					self.performSegueWithIdentifier("Registered", sender: nil)
					
				}else{
					let alert = UIAlertController (title: "Error", message: "Unable to signup. Please ensure all fields are filled and try again.", preferredStyle: .Alert)
					let returnAction = UIAlertAction(title: "Return", style: .Default, handler: nil)
					alert.addAction(returnAction)
					self.presentViewController(alert, animated: true, completion: nil)
					print(error.description)
					
					self.emailTextField.resignFirstResponder()
					self.passwordTextField.resignFirstResponder()
					self.usernameTextField.resignFirstResponder()
					
				}
			})
		}
	}
	
	func loadGIF(){
		let imageView = FLAnimatedImageView()
		imageView.contentMode = UIViewContentMode.ScaleAspectFill
		imageView.animatedImage = GIF
		imageView.frame = self.view.frame
		self.view.addSubview(imageView)
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
