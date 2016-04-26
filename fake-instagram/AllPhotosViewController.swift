//
//  AllPhotosViewController.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit

class AllPhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
	
	var photos = [Photo]()
	@IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
			
        super.viewDidLoad()
			self.tableView.delegate = self
			self.tableView.dataSource = self
        DataService.dataService.PHOTO_REF.observeEventType(.ChildAdded , withBlock: {(snapshot) -> Void in
            if let value = snapshot.value as? [String:AnyObject] {
                let photo = Photo(key: snapshot.key, dict: value)
                self.photos.append(photo)
                self.tableView.reloadData()
            }

        // Do any additional setup after loading the view.
        })
    }

	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	return self.photos.count
	}
	
    @IBAction func onLikeButtonPress(sender: UIButton) {
    }
    
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("") as? PhotoTableViewCell
        let photo = photos[indexPath.row]
        
        
        
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

}
