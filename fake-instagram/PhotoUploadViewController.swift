//
//  PhotoUploadViewController.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit
import FastttCamera

class PhotoUploadViewController: UIViewController, FastttCameraDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
	
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
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		
		self.performSegueWithIdentifier("ConfirmImage", sender: image)
	}
	//MARK: IFTTTFastttCameraDelegate
	
	func cameraController(cameraController: FastttCameraInterface!, didFinishCapturingImage capturedImage: FastttCapturedImage!) {
		print("a photo was taken")
	}
	
	func cameraController(cameraController: FastttCameraInterface!, didFinishScalingCapturedImage capturedImage: FastttCapturedImage!) {
		print("a photo was scaled down")
		if let image = capturedImage.scaledImage as AnyObject? {
			self.performSegueWithIdentifier("ConfirmImage", sender: image)
		}
		
	}
	
	@IBAction func onChooseFromGalleryPressed(sender: UIButton) {
		let gallery = UIImagePickerController()
		gallery.sourceType = .PhotoLibrary
		gallery.delegate = self
		self.fastttRemoveChildViewController(self.fastCamera)
		self.fastttAddChildViewController(gallery)
	}
	
	@IBAction func onTakePicButtonPressed(sender: UIButton) {
		print("take pic button pressed")
		self.fastCamera.takePicture()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let destination = segue.destinationViewController as? PhotoConfirmationUploadViewController {
			if let image = sender as? UIImage {
				destination.image = image
			}
			
		}
	}
}
