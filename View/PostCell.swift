//
//  PostCell.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/13/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

/**
 * @name PostCell
 * @desc class created to represent Post object in TableView
 */
class PostCell: UITableViewCell {
    
    //references to the PostCell created in storyboard
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var birdNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    //variable used to store the associated post
    var post: Post!

    /**
     * @name configCell
     * @desc configures the PostCell with the data from the associated post, and the current location of the user
     * @param Post post - post of which this PostCell will represent
     * @param CLLocationCoordinate2D currLocation - the current user's location
     * @return void
     */
    func configCell(post: Post, currLocation: CLLocationCoordinate2D, image: UIImage? = nil) {
        
        //set PostCell post to passed in Post
        self.post = post
        
        
        //get the location of the Post and the user's current location
        let locOne = CLLocation.init(latitude: CLLocationDegrees.init(post.location[0]), longitude: CLLocationDegrees.init(post.location[1]))
        let locTwo = CLLocation.init(latitude: currLocation.latitude, longitude: currLocation.longitude)
        
        //set distanceLabel equal to the calculated distance string of the Post, pass in distance from post location to user location
        self.distanceLabel.text = post.distanceString(dist: Int(locOne.distance(from: locTwo)))
        
        //set time label to the time since the passed in post was created
        self.timeLabel.text = post.convertDateDifToString()
        
        //set bird name and comment number labels
        self.birdNameLabel.text = post.birdName
        self.commentLabel.text = "\(post.comments)"
        
        //if cell was given image, set cell image to the given image, else download the associated image
        if image != nil {
            self.postImage.image = image
        } else {
            //get reference for the post's image
            let imgRef = DataService.ds.IMAGES_REF.child(post.postKey + ".jpg")
            
            // Download the post's image
            imgRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    //if download was successful, convert data into an image, set PostCell's image to the post image, and add image to cache
                    if let imageData = data {
                        if let loadedImage = UIImage(data: imageData) {
                            self.postImage.image = loadedImage
                            
                            socialListVC.imageCache.setObject(loadedImage, forKey: post.postKey as NSString)
                        }
                    }
                }
            }
        }
    }
    
 }
