//
//  addCommentVC.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/21/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import UIKit
import Firebase

class addCommentVC: UIViewController {
    
    //references to the textView created in the storyboard
    @IBOutlet weak var commentTextView: UITextView!
    
    //variables for the post being commented on
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /**
     * @name post
     * @desc adds a comment to the associated post
     * @param AnyObject sender - sender of the action
     * @return void
     */
    @IBAction func post(_ sender: AnyObject) {
        //database reference for where the comment will be stored
        let comRef = DataService.ds.COMMENTS_REF.child(post.postKey)
        
        if let email = FIRAuth.auth()?.currentUser?.email { //get user's email, continue on success
            
            //guarantee the comment body will be a string
            let comBody = self.commentTextView.text != nil ? self.commentTextView.text! : ""
            
            //create the dictionary that will represent the comment in the database
            let comment: Dictionary<String, Any> = [
                "user": email, //use user's email as username for posted comment
                "commentBody": comBody
            ]
            
            //save comment to database
            comRef.childByAutoId().setValue(comment) { (error, dataRef) in
                if(error != nil) { //if there was an error saving comment, display alert informing user
                    self.showErrorAlert(title: "Comment Not Saved", msg: "Your comment could not be saved. Please try again later.")
                } else {
                    //adjust number of comments on post
                    self.post.adjustComment(addComment: true)
                    
                    //return to post list/map view
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

}
