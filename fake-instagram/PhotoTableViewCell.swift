//
//  PhotoTableViewCell.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 4/22/16.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell{
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var CaptionLabel: UILabel!
    var photoKey = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer.init(target: self, action: "segueToPhoto" )
        addGestureRecognizer(tap)
        
        if let image = imageView?.image{
            
            let likedChange: Selector = "likeSignChange"
            let doubleTapGesture = UITapGestureRecognizer(target: self.imageView, action:likedChange)
            doubleTapGesture.numberOfTapsRequired = 2
            
            
            let likesRef = DataService.dataService.PHOTO_REF.childByAppendingPath(self.photoKey).childByAppendingPath("likes")
            
            //
            //            if let userId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
            //                let dict: [String: AnyObject] = ["liked": liked, "userId":userId]
            //
            //                DataService.dataService.PHOTO_REF.childByAppendingPath().setValue(dict, andPriority: nil, withCompletionBlock: { (error, ref) -> Void in
            //
            //                    DataService.dataService.USER_REF.childByAppendingPath(userId).childByAppendingPath("liked").updateChildValues(ref.key:true)
            //
            //                })
            //            }
            //        }
            
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
        @IBAction func onLikeButtonPressed(sender: AnyObject) {
            
        }
        
        
        
    }

}
