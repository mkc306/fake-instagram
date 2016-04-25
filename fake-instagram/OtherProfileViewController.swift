//
//  OtherProfileViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 25/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController {
    var user : User!
    var isFollowing = false
    override func viewDidLoad() {
        super.viewDidLoad()
        user.key
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
        } else if (self.isFollowing == true){
            self.isFollowing = false
            DataService.dataService.USER_REF.childByAppendingPath(currentUserId).childByAppendingPath("following").childByAppendingPath(self.user.key).removeValue()
            DataService.dataService.USER_REF.childByAppendingPath(self.user.key).childByAppendingPath("followers").childByAppendingPath(currentUserId).removeValue()
        }
    }
    
}



//       DataService.dataService.FOLLOWING_REF.childByAutoId().setValue(dict, andPriority: nil, withCompletionBlock: { (error, ref) -> Void in
//
//            // updates the following number of the user in firebase
//            DataService.dataService.USER_REF.childByAppendingPath(userId).childByAppendingPath("following").updateChildValues([ref.key: true])
//
//
//       })
//    }
//}

//
//    func followingTapped(sender:UITapGestureRecognizer){
//        if let userId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String{
//            let dict = ["counts": numberOfFollowingCount, "userId": userId]
//            // updates the following ref in firebase
//
//                

