//
//  UserListViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 4/22/16.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit

class UserListViewController: UITableViewController {
@IBOutlet weak var searchTextField: UITextField!
var users = [User] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.dataService.USER_REF.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            if let value = snapshot.value as? [String:AnyObject] {
                let user = User(key: snapshot.key, dict: value)
                self.users.append(user)
                self.tableView.reloadData()
            }
    })
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath)
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.username
        cell.layer.borderWidth = 0.8
        cell.layer.borderColor = UIColor.redColor().CGColor
        return cell
    }

  
 

    
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        let itemToMove:User = users[fromIndexPath.row]
        users.removeAtIndex(fromIndexPath.row)
        users.insert(itemToMove, atIndex: toIndexPath.row)

    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
//     MARK: - Navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let destination = segue.destinationViewController as? OtherProfileViewController {
//            let selected = tableView.indexPathForSelectedRow
//            let user = users[selected!.row]
////            destination.user = user
//        }
//       
//    }
//    

}
