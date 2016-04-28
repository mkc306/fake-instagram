//
//  WelcomeViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 25/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit
import Photos

class WelcomeViewController: UIViewController {
	
	override func viewDidLoad() {
		
		AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { (granted) in
			if !granted{
				print("Access denied")
			}
		}
		
		self.checkImageAuthorization()
		
		
		super.viewDidLoad()
		
		
		// Do any additional setup after loading the view.
	}

	
	func checkImageAuthorization() -> Bool{
		//check for permission to access file system assets
		let status = PHPhotoLibrary.authorizationStatus()
		switch status {
		case .Authorized:
			return true
		case .Denied, .Restricted :
			PHPhotoLibrary.requestAuthorization() { (status) -> Void in
				self.checkImageAuthorization()
				return
			}
			return false
		case .NotDetermined:
			// ask for permissions
			PHPhotoLibrary.requestAuthorization() { (status) -> Void in
				self.checkImageAuthorization()
				return
			}
		}
		return false
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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
