//
//  Post.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/13/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import Foundation
import Firebase


/**
 * @name Post
 * @desc class created for post objects
 */
class Post {
    
    //private Post object properties
    private var _time: Int!
    private var _comments: Int!
    private var _birdName: String!
    private var _flaggedAmount: Int!
    private var _location: [Double]!
    private var _postDescription: String!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    
    //public Post object property getters, so code outside this class code cannot change the properties
    var time: Int {
        return _time
    }
    
    var comments: Int {
        return _comments
    }
    
    var birdName: String {
        return _birdName
    }
    
    var flaggedAmount: Int {
        return _flaggedAmount
    }
    
    var location: [Double] {
        return _location
    }
    
    var postDescription: String {
        return _postDescription
    }
    
    var postKey: String {
        return _postKey
    }
    
    
    //initialize the Post object using Dictionary<String, AnyObject>
    init(dictionary: Dictionary<String, AnyObject>) {
        
        //if statements below perform the following:
        // 1. check if dictionary has a value of the correct type for a specified Post property
        // 2. if dictionary has a value for the Post property, set the private property variable to the value from the dictionary
        if let bird = dictionary["birdName"] as? String {
            self._birdName = bird
        }
        
        if let comments = dictionary["comments"] as? Int {
            self._comments = comments
        }
        
        if let time = dictionary["time"] as? Int {
            self._time = time
        }
        
        if let location = dictionary["location"] as? [Double] {
            self._location = location
        }
        
        if let desc = dictionary["descript"] as? String {
            self._postDescription = desc
        }
        
        if let flagged = dictionary["flagged"] as? Int {
            self._flaggedAmount = flagged
        }
        
        if let postKey = dictionary["postKey"] as? String {
            self._postKey = postKey
            
            //set postRef for the Post object to the reference for the postKey value in the posts section of the firebase database
            self._postRef = DataService.ds.POST_REF.child(self.postKey)
        }
        
    }
    
    
    /**
     * @name adjustComment
     * @desc adjusts number of comments on the post
     * @param Bool addComment - for whether a comment is added or removed
     * @return void
     */
    func adjustComment(addComment: Bool) {
        
        //increments or decrements comment count
        if addComment {
            _comments = _comments + 1
        } else {
            _comments = _comments - 1
        }
        
        //updates comment count value for the Post in the database
        _postRef.child("comments").setValue(_comments)
    }
    
    /**
     * @name adjustFlagged
     * @desc adjusts number of flags on the post
     * @param Bool addFlagged - for whether a flag is added or removed
     * @return void
     */
    func adjustFlagged(addFlagged: Bool) {
        
        if addFlagged {
            _flaggedAmount = _flaggedAmount + 1
        } else {
            _flaggedAmount = _flaggedAmount - 1
        }
        
        _postRef.child("flagged").setValue(_flaggedAmount)
    }
    
    
    /**
     * @name convertDateDifToString
     * @desc gets the time from current time since Post was created, and return it as a String
     * @return String
     */
    func convertDateDifToString() -> String {
        
        //String for eventual return
        var dateDifAsString = ""
        
        //get time difference as seconds
        let difference = Int(NSDate().timeIntervalSince1970) - time
        
        //int divide to find time difference in whole minutes
        var difMin = difference/60
        
        if difMin >= 60 { //if minutes is over 60, convert so hours may also be shown
            
            //int divide to get whole hours since post, if over 24 hours convert so days is shown
            let difHours = difMin/60
            if difHours >= 24 {
                let difDays = difHours/24
                
                //ternary operation so that the singularity/plurality of day/days is in line with number
                difDays == 1 ? (dateDifAsString = "1 Day") : (dateDifAsString = "\(difDays) Days")
                
            } else {
                difMin = difMin % 60
                
                //ternary operation so that the singularity/plurality of hour/hours is in line with number
                difHours == 1 ? (dateDifAsString = "1 Hour") : (dateDifAsString = "\(difHours) Hours")
                
                //if hours is less than 10, I deemed minutes also important, so include minutes in the final string as well as hours
                if difHours < 10 {
                    if difMin == 1 {
                        dateDifAsString += " 1 Min Ago"
                    } else {
                        dateDifAsString += " \(difMin) Mins Ago"
                    }
                }
            }
        } else {
            dateDifAsString = "\(difMin) Mins Ago"
        }
        
        //return the completed time since post string
        return dateDifAsString
        
    }
    
    /**
     * @name distanceString
     * @desc converts the int distance in meters to a string specifying the distance
     * @param Int dist - the distance in meters
     * @return String
     */
    func distanceString(dist: Int) -> String {
        
        //if the distance is over 1500 meters, use kilometers with one decimal instead
        if dist > 1500 {
            
            //convert to kilometers
            let distInKm = Float(dist) / 1000.00
            
            //return String representing distance in kilometers with 1 decimal place
            return String(format: "%.1f kilometers", distInKm)
        } else {
            
            //return String representing distance in meters
            return "\(dist) meters"
        }
    }

}
