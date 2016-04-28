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
    var user: [String: AnyObject]!
    var photo: [String: AnyObject]!
    
    init(key: String, dict: [String: AnyObject]){
        self._commentKey = key
        if let body = dict["body"] as? String{
            self.body = body
        }
        
        if let user = dict["user"] as? [String: AnyObject]{
            self.user = user
        }
        
        if let photo = dict["photo"] as? [String: AnyObject]{
            self.photo = photo
        }
    }
    
    var key: String{
        return self._commentKey
    }
}