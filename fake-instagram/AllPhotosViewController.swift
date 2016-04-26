//
//  AllPhotosViewController.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import UIKit
import AlamofireImage

class AllPhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var photos = [Photo]()
    var images = [Image]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let currentUserId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String!
        DataService.dataService.USER_REF.childByAppendingPath(currentUserId).childByAppendingPath("followingFeed").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            DataService.dataService.PHOTO_REF.childByAppendingPath(snapshot.key).observeEventType(.Value , withBlock: {(snapshot3) -> Void in
                if let valueDict = snapshot3.value as? [String:AnyObject] {
                    let photo = Photo(key: snapshot3.key, dict: valueDict)
                    let downloader = imageDownloader
                    var image = Image()
                    let URLRequest = NSURLRequest(URL: NSURL(string: photo.picURL)!)
                    downloader.downloadImage(URLRequest: URLRequest) { response in
                        print(response.request)
                        print(response.response)
                        debugPrint(response.result)
                        if let thisImage = response.result.value{
                            let tempImage = thisImage
                            image = tempImage.af_imageScaledToSize(thisImage.size)
                            self.images.append(image)
                            self.photos.append(photo)
                            self.tableView.reloadData()
                        }
                    }
                    
                }
            })
        })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as? PhotoTableViewCell!
        let image = images[indexPath.row]
        cell?.photoView.image = image
        
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
