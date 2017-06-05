//
//  loginScreenButton.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/13/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import UIKit

/**
 * @name loginScreenButton
 * @desc class for custom designed UIButton to be used on the login screen
 */
@IBDesignable
class loginScreenButton: UIButton {

    //Bool variable to toggle the semitransparent white background on/off
    @IBInspectable var backgroundOn: Bool = false {
        didSet {
            //toggles the semitransparent white background on/off
            if(backgroundOn) {
                backgroundColor = UIColor.white.withAlphaComponent(0.1)
            }
        }
    }
    
    /**
     * @name awakeFromNib
     * @desc overrides awakeFromNib of UIButton so that the loginScreenButton is manipulated by the code
     * @return void
     */
    override func awakeFromNib() {
        
        //curves the corners of the button, sets the border width of the button to 1 and the border color of the button to white
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }

}
