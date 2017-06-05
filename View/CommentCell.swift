//
//  CommentCell.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/22/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

/**
 * @name CommentCell
 * @desc class created to represent Post object in TableView
 */
import UIKit

class CommentCell: UITableViewCell {
    
    //references to the CommentCell created in storyboard
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var comBodyLabel: UILabel!
    
    /**
     * @name configCell
     * @desc configures the CommentCell to conform to the data in the passed in Comment
     * @param Comment comment - comment of which this CommentCell will represent
     * @return void
     */
    func configCell(comment: Comment) {
        
        self.usernameLabel.text = comment.user
        self.comBodyLabel.text = comment.commentBody
        
    }

}
