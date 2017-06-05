//
//  DataService.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/13/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    //singleton instance for dataservice
    static let ds = DataService()
    
    //References for firebase database
    private var _REF_BASE = FIRDatabase.database().reference()
    private var _POST_REF = FIRDatabase.database().reference().child("posts")
    private var _USERS_REF = FIRDatabase.database().reference().child("users")
    private var _COMMENTS_REF = FIRDatabase.database().reference().child("comments")
    
    //References for firebase storage
    private var _STORAGE_REF = FIRStorage.storage().reference(forURL: storageUrl)
    private var _IMAGES_REF = FIRStorage.storage().reference(forURL: storageUrl).child("images")
    private var _USER_PROF_IMAGES_REF = FIRStorage.storage().reference(forURL: storageUrl).child("images").child("users")
    
    //getters for private variables
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var POST_REF: FIRDatabaseReference {
        return _POST_REF
    }
    
    var USERS_REF: FIRDatabaseReference {
        return _USERS_REF
    }
    
    var COMMENTS_REF: FIRDatabaseReference {
        return _COMMENTS_REF
    }
    
    var STORAGE_REF: FIRStorageReference {
        return _STORAGE_REF
    }
    
    var IMAGES_REF: FIRStorageReference {
        return _IMAGES_REF
    }
    
    
    /**
     * @name createFirebaseUser
     * @desc creates a new user in firebase
     * @param String uid - the id used to store the user in firebase
     * @param Dictionary<String, String> user - the dictionary to set user value to
     * @return void
     */
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        //create user with ID of uid and value of user in the USERS_REF area of firebase
        USERS_REF.child(uid).setValue(user)
    }
    
    
    /**
     * @name updateUserPosts
     * @desc adds a post to the user's dictionary of post they have created
     * @param String postId - the id used to store the post in firebase
     * @return void
     */
    func updateUserPosts(postId: String) {
        if let currUser = FIRAuth.auth()?.currentUser { //if there is a current user, get it
            
            //get user uid so user can be located and updated in firebase
            let currUid = currUser.uid
            
            //add postId to user's post array dictionary
            USERS_REF.child(currUid).child("Posts").child(postId).setValue(true)
            
        }
    }
    
    
    /**
     * @name postImageToStorage
     * @desc uploads given picture with given string for name to firebase
     * @param UIImage image - the image to upload
     * @param String name - the name for the image .jpg
     * @return void
     */
    func postImageToStorage(image: UIImage, name: String) {
        
        if let data: Data = UIImageJPEGRepresentation(image, 0.2) { //if image was successfully converted to JPEG rep continue to upload
            
            // Create a reference to the file you want to upload
            let imgRef = DataService.ds._IMAGES_REF.child(name + ".jpg")
            
            
            // Upload the file to the path "images/test.jpg"
            imgRef.put(data, metadata: nil) { metadata, error in
                
                //if there was an error, print it
                if(error != nil) {
                    print("Error")
                    print(error)
                }
            }
        }
    }
    
    
    /**
     * @name changeProfilePicture
     * @desc uploads chosen user profile picture to firebase, then overrides user
     * profile image URL data so the new image is associated with the user
     * @param UIImage image - the image to become the new profile picture
     * @return void
     */
    func changeProfilePicture(image: UIImage) {
        if let user = FIRAuth.auth()?.currentUser { //if there is a current user, get it
            
            //get user uid to use for picture .jpg name
            let picName = user.uid
            
            if let data: Data = UIImageJPEGRepresentation(image, 0.2) { //if image was successfully converted to JPEG rep continue to upload
                
                // Create a reference to the file you want to upload
                let imgRef = DataService.ds._USER_PROF_IMAGES_REF.child(picName + ".jpg")
                
                
                // Upload the file to the path "images/users/(user uid).jpg"
                imgRef.put(data, metadata: nil) { metadata, error in
                    
                    //if there was an error, print it
                    if(error != nil) {
                        print("Error")
                        print(error)
                    }
                }
            }
        }
    }
}
