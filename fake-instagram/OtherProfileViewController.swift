//
//  OtherProfileViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 25/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit
import AlamofireImage
class OtherProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user : User!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    var photos = [Photo]()
    var images = [Image]()
    var anImage = Image()
    
    
    
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
        DataService.dataService.USER_REF.childByAppendingPath(self.user.key).childByAppendingPath("photos").observeEventType(.ChildAdded, withBlock: {
            (snapshot) in
            DataService.dataService.PHOTO_REF.childByAppendingPath(snapshot.key).observeEventType(.Value , withBlock: { (snapshot) -> Void in
                if let valueDict = snapshot.value as? [String:AnyObject] {
                    let photo = Photo(key: snapshot.key, dict: valueDict)
                    self.photos.append(photo)
                    
                    let URLRequest = NSURLRequest(URL: NSURL(string: photo.picURL!)!)
                    imageDownloader.downloadImage(URLRequest: URLRequest) { response in
                        print(response.request)
                        print(response.response)
                        debugPrint(response.result)
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
        cell?.photoView.image = images[indexPath.row]
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




