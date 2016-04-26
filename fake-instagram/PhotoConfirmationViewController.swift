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

class PhotoConfirmationUploadViewController: UIViewController {
	var image = UIImage()
	var s3URL = NSURL()
	let uid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
	let userRef = DataService.dataService.USER_REF
	let photoRef = DataService.dataService.PHOTO_REF
    
	@IBOutlet weak var imageView: UIImageView!
	
	
	override func viewDidLoad() {
		self.imageView.image = self.image
		super.viewDidLoad()
		
		
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
	
	
	@IBAction func onConfirmButtonPressed(sender: UIButton) {
		saveImageLocallyS3Firebase(image)
	}
	
	
	
	
	func saveImageLocallyS3Firebase(image: UIImage){
		
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
	
	func uploadToS3(writePath: NSURL) {
		let ext = "png"
		let uploadRequest = AWSS3TransferManagerUploadRequest()
		uploadRequest.body = writePath
		uploadRequest.key = NSProcessInfo.processInfo().globallyUniqueString + "." + ext
		uploadRequest.bucket = S3BucketName
		self.s3URL = NSURL(string: "http://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
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
				
				print("Uploaded to:\n\(self.s3URL)")
				self.performSegueWithIdentifier("UploadComplete", sender: nil)
			}
			else {
				print("Unexpected empty result.")
			}
			return nil
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.updateFirebase(self.s3URL)
	}
	
	func updateFirebase(url: NSURL){
		let photo = ["picURL": url.absoluteString, "userKey": self.uid, "caption": ""]
		let currentPhotoRef = self.photoRef.childByAutoId()
		currentPhotoRef.updateChildValues(photo)
		self.userRef.childByAppendingPath(self.uid).childByAppendingPath("photos").updateChildValues([currentPhotoRef.key: true])
        self.userRef.childByAppendingPath(self.uid).childByAppendingPath("followers").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.userRef.childByAppendingPath(snapshot.key).childByAppendingPath("followingFeed").updateChildValues([currentPhotoRef.key:true])
            
		print("updated firebase")
	})
    }
}
