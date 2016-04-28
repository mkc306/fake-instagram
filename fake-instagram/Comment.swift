//
//  Comment.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import Foundation

class Comment {
    private let _commentKey: String!
    var body: String!
    var userID: String!
    var photoID: String!
    
    init(key: String, dict: [String: AnyObject]){
        self._commentKey = key
        if let body = dict["body"] as? String{
            self.body = body
        }
        
        if let userID = dict["user"] as? String{
            self.userID = userID
        }
        
        if let photoID = dict["photo"] as? String{
            self.photoID = photoID
        }
    }
    
    var key: String{
        return self._commentKey
    }
}