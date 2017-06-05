//
//  viewPostVC.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/19/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import UIKit
import Firebase

class viewPostVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //references to the image, labels, and tableView created in the storyboard
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var birdNameLabel: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //variables for the post being shown, and the comments associated with the post
    var post: Post!
    var comments = [Comment]()
    
    //variables for post data passed from the selected PostCell
    var sentTime: String!
    var sentDist: String!
    var sentImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        //update the labels and UIImageView to display the post's information
        timeLabel.text = sentTime
        distanceLabel.text = sentDist
        birdNameLabel.text = post.birdName
        descriptLabel.text = post.postDescription
        if sentImage != nil {
            image.image = sentImage
        }
        
        //load comments associated with the displayed post
        loadComments()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue definied in storyboard
        if segue.identifier == COMMENT_SEGUE { //if going to the addCommentVC continue
            if let addComVC = segue.destination as? addCommentVC { //cast the destination of the segue as addCommentVC, continue on sucess
                //set the post for the addCommentVC to the post being displayed                
                addComVC.post = post
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //only want one section
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //want one row per one comment to display
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get comment at given row
        let comment = comments[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as? CommentCell { //dequeue a reusable cell as CommentCell, continue on success
           
            //configure the dequeued CommentCell to conform to the data of the comment associated with this row
            cell.configCell(comment: comment)
            
            //return the configured cell
            return cell
        } else { //if a dequeued cell couldn't be cast as a CommentCell, create a new CommentCell
            return CommentCell()
        }
        
    }
    
    /**
     * @name listButtonPressed
     * @desc retrieve and load the comments associated with the post, store in comments array
     * @return void
     */
    func loadComments() {
        //retrieve comments data from firebase
        DataService.ds.COMMENTS_REF.child(post.postKey).observe(FIRDataEventType.value, with: { (snapshot) in
            
            //clear comment array
            self.comments = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] { //cast the snapshot as an array of snapshots, continue on success
                //iterate over the snapshots gotten
                for snap in snapshots {
                    if let commentDict = snap.value as? Dictionary<String, AnyObject> { //cast value of the snapshot to a dict, continue on success
                        //initialize a comment with the data gotten from the snapshot
                        let comment = Comment(dictionary: commentDict)
                        
                        //add the created comment to the comment array
                        self.comments.append(comment)
                    }
                    
                }
            }
            
            //reload the tableView so the gotten comments will be displayed
            self.tableView.reloadData()
        })
    }
    
    /**
     * @name flagPressed
     * @desc flags the associated post
     * @param AnyObject sender - sender of the action
     * @return void
     */
    @IBAction func flagPressed(_ sender: AnyObject) {
        //adjusts the flag variable for the associated post
        self.post.adjustFlagged(addFlagged: true)
        
        //informs user that they have flagged the post
        self.showErrorAlert(title: "Post Flagged", msg: "");
    }
    

}
