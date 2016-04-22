//
//  DataService.swift
//  fake-instagram
//
//  Created by Jeremy Ong on 22/04/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

import Foundation
import Firebase

class DataService {
	static let dataService = DataService()
	private let _BASE_URL = Firebase(url: BASE_URL)
	
	var BASE_REF: Firebase{
		return _BASE_URL
	}
	
	var USER_REF: Firebase{
		return _BASE_URL.childByAppendingPath("users")
	}
	
	var PHOTO_REF: Firebase{
		return _BASE_URL.childByAppendingPath("photos")
	}
	
	var COMMENT_REF: Firebase{
		return _BASE_URL.childByAppendingPath("comments")
	}
	
}