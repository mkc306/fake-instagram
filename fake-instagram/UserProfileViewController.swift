//
//  UserProfileViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 4/22/16.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit
import AlamofireImage

protocol UserProfileViewControllerDelegate {
    func UserProfileCellCommentButtonClicked()
}


class UserProfileViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    var myPhotos = [Photo]()
    var myImages = [Image]()
    var image = Image()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUserId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String!
        
        
        
        DataService.dataService.USER_REF.childByAppendingPath(currentUserId).childByAppendingPath("profileImageURL").observeEventType(.Value , withBlock: { (snapshot) -> Void in
            if let photoPicURL = snapshot.value as? String {
                let url = NSURL(string:photoPicURL)!
                self.profilePicImageView.af_setImageWithURL(url)
                
                self.profilePicImageView.layer.borderWidth = 1.0
                self.profilePicImageView.layer.masksToBounds = false
                self.profilePicImageView.layer.borderColor = UIColor.blackColor().CGColor
              
                self.profilePicImageView.layer.cornerRadius = 0.5*self.profilePicImageView.frame.height
                self.profilePicImageView.clipsToBounds = true
                
            }
        })
        
        DataService.dataService.USER_REF.childByAppendingPath(currentUserId).childByAppendingPath("photos").observeEventType(.ChildAdded, withBlock: {
            (snapshot) in
            DataService.dataService.PHOTO_REF.childByAppendingPath(snapshot.key).observeEventType(.Value , withBlock: { (snapshot) -> Void in
                
                if let valueDict = snapshot.value as? [String:AnyObject] {
                    let photo = Photo(key: snapshot.key, dict: valueDict)
                    self.myPhotos.append(photo)
                    
                    let URLRequest = NSURLRequest(URL: NSURL(string: photo.picURL)!)
                    imageDownloader.downloadImage(URLRequest: URLRequest) { response in
                        //                        print(response.request)
                        //                        print(response.response)
                        //                        debugPrint(response.result)
                        print("SUCCESSFULLY LOADED IMAGE")
                        if let thisImage = response.result.value{
                            let tempImage = thisImage
                            self.image = tempImage.af_imageScaledToSize(thisImage.size)
                            self.myImages.append(self.image)
                            self.tableView.reloadData()
                        }
                    }
                }
            })
        })
        
        
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
        return self.myImages.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as? PhotoTableViewCell
        cell?.photoView.image = myImages[indexPath.row]
        let photo = myPhotos[indexPath.row]
        cell?.CaptionLabel.text = photo.caption
        cell?.userPhotosDelegate = self
        cell?.photoKey = photo.photoKey
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? CommentsViewController {
            if let photoKey = sender as? String {
                destination.photoKey = photoKey
            }
        }
    }
    
    
    @IBAction func onLogoutButtonPressed(sender: UIButton) {
        let currentUserId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        DataService.dataService.USER_REF.childByAppendingPath(currentUserId!).unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
    }
}



 