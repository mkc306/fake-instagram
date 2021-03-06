//
//  PhotoUploadViewController.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit
import AWSS3
import Photos
import FLAnimatedImage

class ProfilePhotoConfirmationUploadViewController: UIViewController {
	var image = UIImage()
	var s3URL = NSURL()
	let uid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
	let userRef = DataService.dataService.USER_REF
	let photoRef = DataService.dataService.PHOTO_REF
	
	@IBOutlet weak var imageView: UIImageView!
	
	
	
	override func viewDidLoad() {
		
		
		self.imageView.image = self.image
		super.viewDidLoad()
		
	}
	@IBAction func onConfirmButtonPressed(sender: UIButton) {
		loadGIF()
		saveImageLocallyS3Firebase(image)
	}
	
	func saveImageLocallyS3Firebase(image: UIImage){
		
		var writePath = NSURL()
		PHPhotoLibrary.sharedPhotoLibrary().performChanges({
			PHAssetChangeRequest.creationRequestForAssetFromImage(image)
		}) { (success, error) in
			if (success) {
				writePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("instagram.png")
				let imageData = UIImageJPEGRepresentation(image, 0.5)
				imageData?.writeToURL(writePath, atomically: true)
				self.uploadToS3(writePath)
			}
			else {
				print(error?.description)
			}
		}
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
				self.s3URL = NSURL(string: "http://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
				print("Uploaded to:\n\(self.s3URL)")
				NSUserDefaults.standardUserDefaults().setValue(self.s3URL.absoluteString, forKey: "profileImageURL")
				self.userRef.childByAppendingPath(self.uid).updateChildValues(["profileImageURL": self.s3URL.absoluteString])
				uploadRequest.contentType = "image/" + ext
				self.performSegueWithIdentifier("ProfileImageDone", sender: nil)
			}
			else {
				print("Unexpected empty result.")
			}
			return nil
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		print("lulsUserRefUpdated")
	}
	
	func loadGIF(){

		let imageView = FLAnimatedImageView()
		imageView.contentMode = UIViewContentMode.ScaleAspectFill
		imageView.animatedImage = GIF
		imageView.frame = self.view.frame
		self.view.addSubview(imageView)
	}
	
}
