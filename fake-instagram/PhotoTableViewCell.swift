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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer.init(target: self, action: "segueToPhoto" )
        addGestureRecognizer(tap)
        
        if let image = imageView?.image{
            
            let likedSignAnimated: Selector = "likeSignTurnRed"
            let doubleTapGesture = UITapGestureRecognizer(target: self.imageView, action:likedSignAnimated )
            doubleTapGesture.numberOfTapsRequired = 2
            
            
            
            
            if let userId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {let dict = ["liked":liked, "userId":userId]
                
                DataService.dataService.PHOTO_REF.childByAutoId().setValue(dict, andPriority: nil, withCompletionBlock: { (error, ref) -> Void in
                    
                    DataService.dataService.USER_REF.childByAppendingPath(userId).childByAppendingPath("liked").updateChildValues(ref.key: true)
                    
                })
            }
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
        
    }
    
    @IBAction func onLikeButtonPressed(sender: AnyObject) {
    }
    
    func likeSignTurnRed(<#parameters#>) -> <#return type#> {
        <#function body#>
    }
    
}



