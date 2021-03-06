//
//  OtherProfileViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 25/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

protocol OtherProfileViewControllerDelegate {
	func OtherProfileCellCommentButtonClicked()
}

import UIKit
import AlamofireImage

class OtherProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var profilePicView: UIImageView!
	@IBOutlet weak var followButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var followerCountLabel: UILabel!
	@IBOutlet weak var followingCountLabel: UILabel!
	var user : User!
	var photos = [Photo]()
	var images = [Image]()
	var anImage = Image()
	var isFollowing = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let currentUserID = user.key
		
		DataService.dataService.USER_REF.childByAppendingPath(currentUserID).childByAppendingPath("profileImageURL").observeEventType(.Value, withBlock: { (snapshot) -> Void in
			if let photoPicURL = snapshot.value as? String {
				let url = NSURL(string:photoPicURL)!
				self.profilePicView.af_setImageWithURL(url)
			}
		})
		self.profilePicView.layer.borderWidth = 1.0
		self.profilePicView.layer.masksToBounds = false
		self.profilePicView.layer.borderColor = UIColor.blackColor().CGColor
		
		self.profilePicView.layer.cornerRadius = 0.5*self.profilePicView.frame.height
		self.profilePicView.clipsToBounds = true
		
		
		
		self.followButton.layer.borderColor = UIColor.clearColor().CGColor
		self.followButton.backgroundColor = UIColor.greenColor()
		self.followButton.layer.borderWidth = 0
		
		if let userId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String{
			let ref = DataService.dataService.USER_REF.childByAppendingPath(self.user.key).childByAppendingPath("followers").childByAppendingPath(userId)
			ref.observeEventType(.Value, withBlock: {(snapshot) -> Void in
				
				if snapshot.value is NSNull {
					self.isFollowing = false
					self.followButton.layer.borderColor = UIColor.blueColor().CGColor
					self.followButton.layer.borderWidth = 1
					self.followButton.backgroundColor = UIColor.clearColor()
				}
				else {
					self.isFollowing = true
					self.followButton.layer.borderColor = UIColor.clearColor().CGColor
					self.followButton.layer.borderWidth = 0
					self.followButton.backgroundColor = UIColor.greenColor()
					
				}
			})
		}
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.usernameLabel.text = self.user.username
		let followingCount = self.user.following.count
		let followersCount = self.user.followers.count
		self.followingCountLabel.text = "Following: \(followingCount)"
		self.followerCountLabel.text = "Followers: \(followersCount)"
		
		DataService.dataService.USER_REF.childByAppendingPath(self.user.key).childByAppendingPath("profileImageURL").observeEventType(.Value , withBlock: { (snapshot) -> Void in
			if let photoPicURL = snapshot.value as? String {
				let url = NSURL(string:photoPicURL)!
				self.profilePicView.af_setImageWithURL(url)
			}
		})
		DataService.dataService.USER_REF.childByAppendingPath(self.user.key).childByAppendingPath("photos").observeEventType(.ChildAdded, withBlock: {
			(snapshot) in
			DataService.dataService.PHOTO_REF.childByAppendingPath(snapshot.key).observeEventType(.Value , withBlock: { (snapshot) -> Void in
				if let index = self.photos.indexOf({ $0.photoKey == snapshot.key }){
					self.photos.removeAtIndex(index)
					self.images.removeAtIndex(index)
				}
				if let valueDict = snapshot.value as? [String:AnyObject] {
					let photo = Photo(key: snapshot.key, dict: valueDict)
					self.photos.append(photo)
					
					let URLRequest = NSURLRequest(URL: NSURL(string: photo.picURL!)!)
					imageDownloader.downloadImage(URLRequest: URLRequest) { response in
						//                        print(response.request)
						//                        print(response.response)
						//                        debugPrint(response.result)
						print("SUCCESSFULLY LOADED IMAGE")
						if let thisImage = response.result.value{
							let tempImage = thisImage
							self.anImage = tempImage.af_imageScaledToSize(thisImage.size)
							self.images.append(self.anImage)
							self.tableView.reloadData()
						}
					}
				}
			})
		})
		
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.images.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as? PhotoTableViewCell
		let photo = photos[indexPath.row]
		cell?.photoView.image = images[indexPath.row]
		cell?.CaptionLabel.text = photo.caption
		cell?.photoKey = photo.photoKey
		cell?.otherPhotosDelegate = self
		return cell!
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let destination = segue.destinationViewController as? CommentsViewController {
			if let photoKey = sender as? String {
				destination.photoKey = photoKey
			}
		}
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
	@IBAction func OnFollowButtonPress(sender: UIButton) {
		let currentUserId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
		
		if (!isFollowing) {
			isFollowing = true
			DataService.dataService.USER_REF.childByAppendingPath(currentUserId).childByAppendingPath("following").updateChildValues([self.user.key:true])
			DataService.dataService.USER_REF.childByAppendingPath(self.user.key).childByAppendingPath("followers").updateChildValues([currentUserId!:true])
			followButton.setTitle("Unfollow", forState: UIControlState.Normal)
			
			DataService.dataService.USER_REF.childByAppendingPath(self.user.key).childByAppendingPath("photos").observeEventType(.Value, withBlock: { (snapshot) -> Void in
				if let valueDict = snapshot.value as? [String:AnyObject] {
					DataService.dataService.USER_REF.childByAppendingPath(currentUserId).childByAppendingPath("followingFeed").updateChildValues(valueDict)
					self.followButton.backgroundColor = UIColor.greenColor()
					
					
				}
				
				
			})
		} else if (self.isFollowing == true){
			self.isFollowing = false
			DataService.dataService.USER_REF.childByAppendingPath(currentUserId).childByAppendingPath("following").childByAppendingPath(self.user.key).removeValue()
			DataService.dataService.USER_REF.childByAppendingPath(self.user.key).childByAppendingPath("followers").childByAppendingPath(currentUserId).removeValue()
			followButton.setTitle("Follow+", forState: UIControlState.Normal)
			self.followButton.layer.borderColor = UIColor.blueColor().CGColor
			self.followButton.layer.borderWidth = 1
			self.followButton.backgroundColor = UIColor.clearColor()
		}
	}
	
}




