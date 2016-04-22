//
//  SignupViewController.swift
//  fake-instagram
//
//  Created by Michael Kelvyn Chan on 4/22/16.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onRegisterButtonPress(sender: UIButton) {
        
        if let email = emailTextField.text,let password = passwordTextField.text,let username = usernameTextField.text{
            
            let rootReference = DataService.dataService.BASE_REF
            rootReference.createUser(email, password: password, withValueCompletionBlock: {(error,result) -> Void in
                if error == nil{
                    let uid = result["uid"] as? String
                    let userDict = ["email": email, "username":username]
                    let currentUser = rootReference.childByAppendingPath("insta").childByAppendingPath(uid)
                    currentUser.setValue(userDict)
                    NSUserDefaults.standardUserDefaults().setValue(uid, forKey: "uid")
                    self.performSegueWithIdentifier("LoggedIn", sender: nil)
                    
                }else{
                    print(error)
                    
                    
                    
                    
                }
                
                
            })
           
            
        }
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
