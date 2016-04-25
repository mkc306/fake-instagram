//
//  OtherProfileViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 25/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user : User!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    
    var isFollowing = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
                 self.usernameLabel.text = self.user.username
            let followingCount = self.user.following.count
            let followersCount = self.user.followers.count
            
            self.followingCountLabel.text = "Following: \(followingCount)"
            self.followerCountLabel.text = "Followers: \(followersCount)"
        
    }
    
  
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as? PhotoTableViewCell
        return cell!
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
            
        } else if (self.isFollowing == true){
            self.isFollowing = false
            DataService.dataService.USER_REF.childByAppendingPath(currentUserId).childByAppendingPath("following").childByAppendingPath(self.user.key).removeValue()
            DataService.dataService.USER_REF.childByAppendingPath(self.user.key).childByAppendingPath("followers").childByAppendingPath(currentUserId).removeValue()
            followButton.setTitle("Follow+", forState: UIControlState.Normal)
        }
    }
    
}




