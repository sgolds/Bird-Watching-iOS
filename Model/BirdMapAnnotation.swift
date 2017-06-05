//
//  BirdMapAnnotation.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/25/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import Foundation
import MapKit

/**
 * @name BirdMapAnnotation
 * @desc class created for the custom annotations on MapView
 */
class BirdMapAnnotation: NSObject, MKAnnotation {
    
    //BirdMapAnnotation properties
    let title: String?
    let postAge: String?
    let coordinate: CLLocationCoordinate2D
    let post: Post
    var isGreen: Bool = true
    
    
    //initialize the BirdMapAnnotation using provided post
    init(post: Post) {
        self.post = post
        
        //set annotation title to the bird name associated with the post
        self.title = post.birdName
        
        //set postAge to the calculated time from current time to post creation time
        self.postAge = post.convertDateDifToString()
        
        //if the post has not been flagged, the annotation will be green, otherwise will be red
        if(post.flaggedAmount != 0) {
            self.isGreen = false
        }
        
        //set coordinate to the associated post's location
        self.coordinate = CLLocationCoordinate2D(latitude: post.location[0], longitude: post.location[1])
        
        super.init()
    }
    
    //set the annotation's subtitle to postAge
    var subtitle: String? {
        return postAge
    }
    
}
