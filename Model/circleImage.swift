//
//  circleImage.swift
//  Bird Watching
//
//  Created by Sten Golds on 11/5/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import UIKit

/**
 * @name circleImage
 * @desc class for displaying circular images
 */
class circleImage: UIImageView {

    /**
     * @name postImageToStorage
     * @desc overrides layoutSubviews of UIImageView so that the circleImage image is displayed as a circle
     * @return void
     */
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
