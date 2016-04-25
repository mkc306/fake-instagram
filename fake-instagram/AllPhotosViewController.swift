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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return self.photos.
		return 0
	}
	
    @IBAction func onLikeButtonPress(sender: UIButton) {
    }
    
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("") as? PhotoTableViewCell
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
