//
//  USer.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import Foundation

class User {
	
	private let _userKey: String!
	var username: String!
	var following: [String: AnyObject]!
	var followers: [String: AnyObject]!
	var liked: [String: AnyObject]!
	var comments: [String: AnyObject]!
	var email: String!
	var profileImageURL: String!
	var photos: [String: AnyObject]!
	
	
	init(key: String, dict:[String: AnyObject]){
		self._userKey = key
		if let username = dict["username"] as? String{
			self.username = username
		}
		if let following = dict["following"] as? [String: AnyObject]{
			self.following = following
        }else{
            self.following = [:]
        }
		if let followers = dict["followers"] as? [String: AnyObject]{
			self.followers = followers
        }else{
            self.followers = [:]
        }
		if let liked = dict["liked"] as? [String: AnyObject]{
			self.liked = liked
		}
		if let comments = dict["comments"] as? [String: AnyObject]{
			self.comments = comments
		}
		if let email = dict["email"] as? String{
			self.email = email
		}
		
		if let profileImageURL = dict["profileImageURL"] as? String{
			self.profileImageURL = profileImageURL
		}
		
		if let photos = dict["photos"] as? [String: AnyObject]{
			self.photos = photos
		}
	}
	
	var key: String {
		return _userKey
	}

}