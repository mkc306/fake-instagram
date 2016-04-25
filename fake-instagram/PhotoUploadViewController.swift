//
//  PhotoUploadViewController.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit
import FastttCamera
import AWSS3
import Photos

class PhotoUploadViewController: UIViewController, FastttCameraDelegate {
	
	@IBOutlet weak var cameraView: UIView!
	let fastCamera = FastttCamera()
	
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		self.fastCamera.delegate = self
		
		self.fastttAddChildViewController(self.fastCamera)
		
		self.fastCamera.view.frame = self.cameraView.frame
		
		// Do any additional setup after loading the view.
	}
	
	//	@IBAction func onTakePicButtonPressed(sender: UIBarButtonItem) {
	//		print("take pic button pressed")
	//		self.fastCamera.takePicture()
	//	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	//MARK: IFTTTFastttCameraDelegate
	
	func cameraController(cameraController: FastttCameraInterface!, didFinishCapturingImage capturedImage: FastttCapturedImage!) {
		print("a photo was taken")
	}
	
	func cameraController(cameraController: FastttCameraInterface!, didFinishScalingCapturedImage capturedImage: FastttCapturedImage!) {
		print("a photo was scaled down")
		self.performSegueWithIdentifier("ConfirmImage", sender: capturedImage.scaledImage)
	}
	
	
	@IBAction func onChooseFromGalleryPressed(sender: UIButton) {
		let gallery = UIImagePickerController()
		gallery.sourceType = .PhotoLibrary
		self.fastttRemoveChildViewController(self.fastCamera)
		
	}
	
	@IBAction func onTakePicButtonPressed(sender: UIButton) {
		print("take pic button pressed")
		self.fastCamera.takePicture()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let destination = segue.destinationViewController as? PhotoConfirmationUploadViewController
		destination?.imageView.image = sender as? UIImage
	}
}
