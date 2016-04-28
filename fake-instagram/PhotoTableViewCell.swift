//
//  PhotoTableViewCell.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 4/22/16.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit


class PhotoTableViewCell: UITableViewCell, AllPhotosViewControllerDelegate, OtherProfileViewControllerDelegate, UserProfileViewControllerDelegate {
	@IBOutlet weak var addCommentButton: UIButton!
	@IBOutlet weak var likeButton: UIButton!
	@IBOutlet weak var photoView: UIImageView!
	@IBOutlet weak var CaptionLabel: UILabel!
	var photoKey = String()
	var allPhotosDelegate: AllPhotosViewController?
	var otherPhotosDelegate: OtherProfileViewController?
	var userPhotosDelegate: UserProfileViewController?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onLikeButtonPressed(_:)))
		doubleTapGesture.numberOfTapsRequired = 2
		self.photoView.addGestureRecognizer(doubleTapGesture)
		self.photoView.userInteractionEnabled = true
		
		let tap = UITapGestureRecognizer.init(target: self, action: #selector(PhotoTableViewCell.segueToPhoto) )
		tap.requireGestureRecognizerToFail(doubleTapGesture)
		addGestureRecognizer(tap)
		
	}
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	func segueToPhoto(){
		let view = self.window?.rootViewController?.presentedViewController
		let storyboard = UIStoryboard(name: "FeedViews", bundle: nil)
		let nextViewController = storyboard.instantiateViewControllerWithIdentifier("PhotoViewController")
		view?.presentViewController(nextViewController, animated: true, completion: nil)
	}
	
	func allPhotosCellCommentButtonClicked() {
		if let vc = self.window?.rootViewController as? AllPhotosViewController{
			vc.performSegueWithIdentifier("Comments", sender: self.photoKey)
		}
	}
	
	
	func UserProfileCellCommentButtonClicked() {
		if let vc = self.window?.rootViewController as? UserProfileViewController{
			vc.performSegueWithIdentifier("Comments", sender: self.photoKey)
		}
	}
	
	func OtherProfileCellCommentButtonClicked() {
		if let vc = self.window?.rootViewController as? OtherProfileViewController{
			vc.performSegueWithIdentifier("Comments", sender: self.photoKey)
		}
	}
	
	func onLikeButtonPressed(recognizer: UITapGestureRecognizer) {
		if let userId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String{
			let ref = DataService.dataService.PHOTO_REF.childByAppendingPath(self.photoKey).childByAppendingPath("likes").childByAppendingPath(userId)
			
			
			
			ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
				if snapshot.value is NSNull{
					DataService.dataService.PHOTO_REF.childByAppendingPath(self.photoKey).childByAppendingPath("likes").updateChildValues([userId : true])
					DataService.dataService.USER_REF.childByAppendingPath(userId).childByAppendingPath("liked").updateChildValues([self.photoKey : true])
					self.likeButton.setImage(UIImage(named:"like_button"), forState:UIControlState.Normal)
				}else{
					ref.removeValue()
					DataService.dataService.USER_REF.childByAppendingPath("uid").childByAppendingPath("liked").removeValue()
					self.likeButton.setImage(UIImage(named:"liked_button"), forState:UIControlState.Normal)
				}
			})
			
		}
		
	}
	
	@IBAction func onCommentButtonPress(sender: UIButton) {
		allPhotosCellCommentButtonClicked()
		OtherProfileCellCommentButtonClicked()
		UserProfileCellCommentButtonClicked()
	}
	
	
	
	
}

