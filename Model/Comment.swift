//
//  Comment.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/19/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import Foundation
import Firebase

/**
 * @name Comment
 * @desc class created for comment objects
 */
class Comment {
    
    //private Comment object properties
    private var _user: String!
    private var _commentBody: String!
    
    //public Comment object property getters, so code outside this class code cannot change the properties
    var user: String {
        return _user
    }
    
    var commentBody: String {
        return _commentBody
    }
    
    //initialize Comment with provided user String and commentBody String
    init(user: String, commentBody: String) {
        self._user = user 
        self._commentBody = commentBody
    }
    
    //initialize Comment using Dictionary<String, AnyObject>
    init(dictionary: Dictionary<String, AnyObject>) {
        
        //if statements below perform the following:
        // 1. check if dictionary has a value of the correct type for a specified Comment property
        // 2. if dictionary has a value for the Comment property, set the private property variable to the value from the dictionary
        if let user = dictionary["user"] as? String {
            self._user = user
        }
        
        if let commentBody = dictionary["commentBody"] as? String {
            self._commentBody = commentBody
        }
    }
}
