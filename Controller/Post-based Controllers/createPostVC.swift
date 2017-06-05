//
//  createPostVC.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/14/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class createPostVC: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChooseImageAction {
   
    //references to the image and TextFields created in the storyboard
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var birdNameTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    
    //initialize imagePicker and Bool to toggle if the user selected an image or not
    var imagePicker = UIImagePickerController()
    var imageSelected = false
    
    let locationManager: CLLocationManager = CLLocationManager()
    var currLocation: CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        locationManager.delegate = self

        //ask for authorization from the user for always getting location
        self.locationManager.requestAlwaysAuthorization()
        
        //ask for authorization from the user for getting their location when using the app
        self.locationManager.requestWhenInUseAuthorization()
        
        //if location services are authorized, set delegate, accuracy, and start updating locations
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    /**
     * @name imagePickerControllerDidCancel
     * @desc dismisses the image picker controller if the controller canceled
     * @param UIImagePickerController picker - the image picker controller
     * @return void
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /**
     * @name imagePickerController - didFinishPickingMediaWithInfo
     * @desc gets the chosen image, sets the createPostVC image to the selected image
     * and toggles the Bool to show an image has been selected, finally dismisses picker
     * @param UIImagePickerController picker - the image picker controller
     * @param [String : AnyObject] info - the media info selected
     * @return void
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //attempts to get a UIImage out of the selected media, continues if UIImage was successfully grabbed
        //sets image to the grabbed UIImage, and toggles imageSelected Bool to true
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.image.image = image
            imageSelected = true
        }
        
        //dismisses picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    /**
     * @name selectImageGesture
     * @desc when user taps the imageView this function opens an action sheet allowing the user edit the post image
     * by choosing 1. upload a photo from camera roll, 2. take a photo, 3. cancel decision to edit the post image
     * if 1 or 2 is selected, presents the imagePicker
     * @param AnyObject sender - the sender of the action
     * @return void
     */
    @IBAction func selectImageGesture(_ sender: AnyObject) {
        
        //call choose image function defined in ChooseImageAction
        //protocol and extension
        chooseImage(ForView: sender)
        
    }
    
    
    /**
     * @name selectImageGesture
     * @desc create a new post with the user given information
     * @param AnyObject sender - the sender of the action
     * @return void
     */
    @IBAction func postPressed(sender: AnyObject) {
        if(imageSelected == true && birdNameTF.text != "") { //continue if user has selected an image
            
            //get the current user's location as doubles
            let long = Double(currLocation.longitude)
            let lat = Double(currLocation.latitude)
            
            //get the description
            let descriptText = (descriptionTF.text != nil) ? descriptionTF.text! : ""
            
            //get the bird name
            let bName = (birdNameTF.text != nil) ? birdNameTF.text! : ""
            
            //create a firebase datatbase reference for the new post
            let refForNewPost = DataService.ds.POST_REF.childByAutoId()
            
            //set postKey to the autoId created for the post reference
            let postKey = refForNewPost.key
            
            //if there is an image upload it to storage with .jpg name of postKey
            if let img = self.image.image {
                DataService.ds.postImageToStorage(image: img, name: postKey)
            }
            
            //create the dictionary that will represent the post in the database
            let post: Dictionary<String, Any> = [
                "birdName": bName,
                "comments": 0, //initially 0
                "time": Int(NSDate().timeIntervalSince1970), //current time since 1970
                "location": [lat, long],
                "descript": descriptText,
                "flagged": 0, //initially 0
                "postKey": postKey
            ]
            
            //save post to database
            refForNewPost.setValue(post) { (error, dataRef) in
                if(error != nil) { //if there was an error saving post, display alert informing user
                    self.showErrorAlert(title: "Post Not Saved", msg: "Your post could not be saved. Please try again later.")
                } else {
                    //update the user's posts array to contain the new post
                    DataService.ds.updateUserPosts(postId: postKey)
                    
                    //return to post list/map view
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            //display to user that the post requires both an image and bird name
            showErrorAlert(title: "Post requires an image and the bird name", msg: "Enter N/A if you do not know the name of the bird")
        }
    }
    
    /**
     * @name touchesBegan
     * @desc overrides touchesBegan function in order to make the keyboard disappear if the user taps outside the keyboard
     * and TextField area
     * @param Set<UITouch> touches - set of touches by the user
     * @param UIEvent event - event associated with the touches
     * @return void
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        birdNameTF.resignFirstResponder()
        descriptionTF.resignFirstResponder()
    }
    
    /**
     * @name locationManager - didUpdateLocations
     * @desc update the users current location variable as the current location changes
     * @param CLLocationManager manager - manager used to get current user's location
     * @param [CLLocation] locations - array of new location data
     * @return void
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue:CLLocationCoordinate2D = manager.location?.coordinate {
            currLocation = locValue
        }
    }

}
