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
        let imageDownloader = ImageDownloader(
            configuration: ImageDownloader.defaultURLSessionConfiguration(),
            downloadPrioritization: .FIFO,
            maximumActiveDownloads: 4,
            imageCache: AutoPurgingImageCache()
        )
			self.tableView.delegate = self
			self.tableView.dataSource = self
        DataService.dataService.PHOTO_REF.observeEventType(.ChildAdded , withBlock: {(snapshot) -> Void in
            if let value = snapshot.value as? [String:AnyObject] {
                let photo = Photo(key: snapshot.key, dict: value)
                let downloader = imageDownloader
                var image = Image()
                let URLRequest = NSURLRequest(URL: NSURL(string: photo.picURL)!)
                downloader.downloadImage(URLRequest: URLRequest) { response in
                    print(response.request)
                    print(response.response)
                    debugPrint(response.result)
                    
                     image = response.result.value!
                    
                }
                self.photos.append(photo)
                self.images.append(image)
                self.tableView.reloadData()
            }

        // Do any additional setup after loading the view.
        })
    }
    
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	return self.images.count
	}
	
    @IBAction func onLikeButtonPress(sender: UIButton) {
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
