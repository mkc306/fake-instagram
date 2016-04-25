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
		saveImageLocallyAndS3(capturedImage.scaledImage)
	}
	
	func saveImageLocallyAndS3(image: UIImage){
		
		var writePath = NSURL()
		PHPhotoLibrary.sharedPhotoLibrary().performChanges({
			PHAssetChangeRequest.creationRequestForAssetFromImage(image)
			}) { (success, error) in
				if (success) {
					writePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("instagram.png")
					let imageData = UIImagePNGRepresentation(image)
					imageData?.writeToURL(writePath, atomically: true)
					self.uploadToS3(writePath)
				}
				else {
					print(error?.description)
				}
		}
		
		
	}
	
	@IBAction func onTakePicButtonPressed(sender: UIButton) {
		print("take pic button pressed")
		self.fastCamera.takePicture()
	}
	
	func uploadToS3(writePath: NSURL) {
		let ext = "png"
		let uploadRequest = AWSS3TransferManagerUploadRequest()
		uploadRequest.body = writePath
		uploadRequest.key = NSProcessInfo.processInfo().globallyUniqueString + "." + ext
		uploadRequest.bucket = S3BucketName
		uploadRequest.contentType = "image/" + ext
		let transferManager = AWSS3TransferManager.defaultS3TransferManager()
		transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
			if let error = task.error {
				print("Upload failed ❌ (\(error))")
			}
			if let exception = task.exception {
				print("Upload failed ❌ (\(exception))")
			}
			if task.result != nil {
				let s3URL = NSURL(string: "http://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
				print("Uploaded to:\n\(s3URL)")
			}
			else {
				print("Unexpected empty result.")
			}
			return nil
		}
	}
}
