//
//  PhotoUploadViewController.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit
import FastttCamera
import Photos

class ProfilePhotoUploadViewController: UIViewController, FastttCameraDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
	
	
	@IBOutlet weak var cameraView: UIView!
	let fastCamera = FastttCamera()
	
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		self.fastCamera.delegate = self
		
		self.fastttAddChildViewController(self.fastCamera)
		
		self.fastCamera.view.frame = self.cameraView.frame
		
		// Do any additional setup after loading the view.
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		print("picked item in gallery")
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
		PHPhotoLibrary.requestAuthorization { (status) in
			if status != PHAuthorizationStatus.Authorized{
				print("Access denied")
			}
		}
		let gallery = UIImagePickerController()
		gallery.sourceType = .PhotoLibrary
		gallery.delegate = self
		self.fastttRemoveChildViewController(self.fastCamera)
		self.fastttAddChildViewController(gallery)
	}
	
	@IBAction func onRotateCameraPressed(sender: AnyObject) {
		var device: FastttCameraDevice
		switch self.fastCamera.cameraDevice {
			case FastttCameraDevice.Rear:
				device = FastttCameraDevice.Front
				break
			case FastttCameraDevice.Front:
				device = FastttCameraDevice.Rear
				break
			default:
				print("noob camera")
		}
		if FastttCamera.isCameraDeviceAvailable(device) {
			self.fastCamera.cameraDevice = device
		}
	}
	
	
	
	@IBAction func onTakePicButtonPressed(sender: UIButton) {
		print("take pic button pressed")
		self.fastCamera.takePicture()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let destination = segue.destinationViewController as? ProfilePhotoConfirmationUploadViewController {
			if let image = sender as? UIImage {
				destination.image = UIImage(data: UIImageJPEGRepresentation(image, 0.6)!)!
			}
			
		}
	}

}
