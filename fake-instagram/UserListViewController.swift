//
//  UserListViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 4/22/16.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit

class UserListViewController: UITableViewController, UITextFieldDelegate {
@IBOutlet weak var searchTextField: UITextField!
var users = [User] ()
var filteredUsers = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.dataService.USER_REF.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            if let value = snapshot.value as? [String:AnyObject] {
                let user = User(key: snapshot.key, dict: value)
                self.users.append(user)
                self.filteredUsers = self.users
                self.tableView.reloadData()
            }
    })
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    
    }
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredUsers.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath)
        let user = self.filteredUsers[indexPath.row]
        cell.textLabel?.text = user.username
        cell.layer.borderWidth = 0.8
        cell.layer.borderColor = UIColor.redColor().CGColor
        return cell
    }

  
 

    
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath,toIndexPath: NSIndexPath) {
        
        let itemToMove:User = filteredUsers[fromIndexPath.row]
        filteredUsers.removeAtIndex(fromIndexPath.row)
        filteredUsers.insert(itemToMove, atIndex: toIndexPath.row)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
            if let text = searchTextField.text{
                if text == "" {
                    filteredUsers = users
                }else {
                    
                    filteredUsers = self.users.filter({ $0.username.hasPrefix(text)})
                }
            }
            searchTextField.resignFirstResponder()
            tableView.reloadData()
        return true
    }




    
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
