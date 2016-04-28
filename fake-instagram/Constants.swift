//
//  Constants.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import Foundation
import AlamofireImage
import FLAnimatedImage

let BASE_URL = "https://fake-instagram.firebaseio.com"

let CognitoRegionType = AWSRegionType.USEast1  // e.g. AWSRegionType.USEast1
let DefaultServiceRegionType = AWSRegionType.USEast1 // e.g. AWSRegionType.USEast1
let CognitoIdentityPoolId = "us-east-1:5dfaa5d7-9827-466a-9912-a645bbdb5be0"
let S3BucketName = "instagram-fake"
let imageDownloader = ImageDownloader(
    configuration: ImageDownloader.defaultURLSessionConfiguration(),
    downloadPrioritization: .FIFO,
    maximumActiveDownloads: 4,
    imageCache: AutoPurgingImageCache())
let PATH_OF_GIF = NSBundle.mainBundle().pathForResource("loading-gif", ofType: "gif")
let DATA = NSFileManager.defaultManager().contentsAtPath(PATH_OF_GIF!)
let GIF = FLAnimatedImage(animatedGIFData: DATA!)