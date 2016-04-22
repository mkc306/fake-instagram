//
//  PhotoUploadViewController.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit
import FastttCamera

class PhotoUploadViewController: UIViewController, FastttCameraDelegate {
	
	let fastCamera = FastttCamera()
	
	
    override func viewDidLoad() {
			
        super.viewDidLoad()
			self.fastCamera.delegate = self
			
			self.fastttAddChildViewController(self.fastCamera)
			self.fastCamera.view.frame = self.view.frame
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

}
