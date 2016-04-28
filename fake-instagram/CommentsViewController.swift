
//
//  CommentsViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 28/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
	@IBOutlet weak var commentTextField: UITextField!
	var photoKey = String()
	@IBOutlet weak var tableView: UITableView!
	var comments = [Comment] ()
	override func viewDidLoad() {
		super.viewDidLoad()
		
		DataService.dataService.PHOTO_REF.childByAppendingPath(self.photoKey).childByAppendingPath("comments").observeEventType(.ChildAdded, withBlock: { (snapshot) in
			DataService.dataService.COMMENT_REF.childByAppendingPath(snapshot.key).observeEventType(.Value, withBlock: { (snapshot) in
				if let value  = snapshot.value as? [String:AnyObject] {
					let comment = Comment(key: snapshot.key, dict: value)
					self.comments.append(comment)
					
					
					self.tableView.reloadData()
				}
			})
		})
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell")!
		let comment = comments[indexPath.row]
		cell.textLabel?.text = comment.body
		DataService.dataService.USER_REF.childByAppendingPath(comment.userID).observeEventType(.Value, withBlock: { (snapshot) in
			if let value = snapshot.value as? [String:AnyObject] {
				let user = User(key: snapshot.key, dict: value)
				cell.detailTextLabel?.text = user.username
			}
		})
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.comments.count
	}
	
	@IBAction func onNewCommentAdded(sender: UIButton) {
		let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
		let dict = ["userID":currentUserID!,"photoID":photoKey]
		let newComment =  DataService.dataService.COMMENT_REF.childByAutoId()
		let comment = Comment(key: newComment.key, dict: dict)
		comment.body = commentTextField.text
		comment.userID = currentUserID!
		comment.photoID = self.photoKey
		
		newComment.childByAppendingPath("body").setValue(commentTextField.text)
		newComment.childByAppendingPath("user").setValue(currentUserID!)
		newComment.childByAppendingPath("photo").setValue(self.photoKey)
		
		DataService.dataService.PHOTO_REF.childByAppendingPath(self.photoKey).childByAppendingPath("comments").updateChildValues([newComment.key:true])
		DataService.dataService.USER_REF.childByAppendingPath(currentUserID!).childByAppendingPath("comments").updateChildValues([newComment.key:true])
		
		
		tableView.reloadData()
	}
	
	@IBAction func onBackButtonPressed(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.commentTextField.resignFirstResponder()
		return true
	}
	
	
}
