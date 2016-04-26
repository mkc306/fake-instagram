//
//  UserProfileViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 4/22/16.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
	
	@IBOutlet weak var tableView: UITableView!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width/2
        profilePicImageView.clipsToBounds = true
        let currentUserId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String!
        DataService.dataService.USER_REF.childByAppendingPath(currentUserId).observeEventType(.Value , withBlock: { (snapshot) -> Void in
            if let value = snapshot.value as? [String:AnyObject] {
                let user = User(key: snapshot.key , dict: value)
                self.usernameLabel.text = user.username
                let followingCount = user.following.count
                let followersCount = user.followers.count
            
              self.followingCountLabel.text = "Following: \(followingCount)"
              self.followerCountLabel.text = "Followers: \(followersCount)"
            }
    
        })
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as? PhotoTableViewCell
        return cell!
    }
    
 
}
 