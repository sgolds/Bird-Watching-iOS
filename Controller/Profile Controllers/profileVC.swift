//
//  profileVC.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/16/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import UIKit
import Firebase

class profileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChooseImageAction {

    //references to the profile picture UIImageView and email label created in the storyboard
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    //initialize imagePicker, Bool to toggle if the user selected an image or not
    //and Bool for if the profile image is loaded
    var imagePicker = UIImagePickerController()
    var imageSelected = false
    var imageLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        if let user = FIRAuth.auth()?.currentUser, imageLoaded == false { //get current user, continue on success
            //set email label to user's email
            self.emailLabel.text = user.email
            
            if let imageUrl = user.photoURL { //get user's profile image URL, continue on success
                
                //create database reference where the image is stored
                let ref = FIRStorage.storage().reference(forURL: imageUrl.absoluteString)
                
                //download user's profile image
                ref.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print(error)
                    } else {
                        print("Image successfully downloaded")
                        
                        //if image data was downloaded successfully
                        //convert data to UIImage and set the profile ImageView to display the downloaded image
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.profilePicture.image = img
                                self.imageLoaded = true
                            }
                        }
                    }
                })
            }
        }
        
    }
    
    /**
     * @name signOutPressed
     * @desc sign out the user
     * @param AnyObject sender - the sender of the action
     * @return void
     */
    @IBAction func signOutPressed(sender: AnyObject) {
        do { //attempt to sign the user out
            try FIRAuth.auth()?.signOut() //app delegate will load the login view
        } catch {
            //if user could not be signed out, inform them of that
            showErrorAlert(title: "Could not sign out", msg: "Try again in a few minutes")
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
     * @desc gets the chosen image, sets the profile picture to the selected image
     * and toggles the Bool to show an image has been selected, changes the user's profile image to the new image,
     * and finally dismisses the picker
     * @param UIImagePickerController picker - the image picker controller
     * @param [String : AnyObject] info - the media info selected
     * @return void
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //attempts to get a UIImage out of the selected media, continues if UIImage was successfully grabbed
        //sets profilePicture to the grabbed UIImage, and toggles imageSelected Bool to true
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.profilePicture.image = image
            imageSelected = true
            
            //change's the user's profile picture in firebase
            DataService.ds.changeProfilePicture(image: image)
        }
        
        //dismisses picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    /**
     * @name changePicturePressed
     * @desc when user taps the change picture button this function opens an action sheet allowing the user edit their profile image
     * by choosing 1. upload a photo from camera roll, 2. take a photo, 3. cancel decision to edit the post image
     * if 1 or 2 is selected, presents the imagePicker
     * @param AnyObject sender - the sender of the action
     * @return void
     */
    @IBAction func changePicturePressed(_ sender: AnyObject) {
        //call choose image function defined in ChooseImageAction
        //protocol and extension
        chooseImage(ForView: sender)
    }
    

}
