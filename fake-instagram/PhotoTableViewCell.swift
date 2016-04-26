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
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
	
	@IBAction func onLikeButtonPressed(sender: AnyObject) {
	}
		
    
    func segueToPhoto(){
        let view = self.window?.rootViewController?.presentedViewController
        let storyboard = UIStoryboard(name: "FeedViews", bundle: nil)
        let nextViewController = storyboard.instantiateViewControllerWithIdentifier("PhotoViewController")
        view?.presentViewController(nextViewController, animated: true, completion: nil)
    }
        
        
        
    
}
