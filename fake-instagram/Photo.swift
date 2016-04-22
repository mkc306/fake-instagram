//
//  Photo.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import Foundation


class Photo{
	private let _photoKey: String!
	var picURL: String!
	var likes: [String: AnyObject]!
	var user: [String: AnyObject]!
	var caption: String!
	var comments: [String: AnyObject]!
	
	
	
	init(key: String, dict:[String: AnyObject]){
		self._userKey = key
		if let picURL = dict["picURL"] as? String{
			self.picURL = picURL
		}
		if let likes = dict["likes"] as? [String: AnyObject]{
			self.following = following
		}
		if let followers = dict["followers"] as? [String: AnyObject]{
			self.followers = followers
		}
		if let likes = dict["likes"] as? [String: AnyObject]{
			self.likes = likes
		}
		if let comments = dict["comments"] as? [String: AnyObject]{
			self.comments = comments
		}
		if let uploader = dict["uploader"] as? [String: AnyObject]{
			self.user = uploader
		}
	}
	
	var key: String {
		return _photoKey
	}
	
	var userKey: String {
		return _userKey
	}
}