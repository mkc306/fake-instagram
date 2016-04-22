//
//  UserProfileViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 4/22/16.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell")!
        return cell;
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
