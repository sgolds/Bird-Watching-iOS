//
//  underlinedWhiteTF.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/13/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import UIKit

/**
 * @name underlinedWhiteTF
 * @desc class for changing the UITextField into a clear UITextField with a white underline, and semitransparent white placeholder
 * font color
 */
@IBDesignable
class underlinedWhiteTF: UITextField {

    //creates immutable variables for the underline (border), and the width of the underline (width)
    let border = UIBezierPath()
    
    //IBInspectables to set color and width of TF border
    @IBInspectable var color: UIColor = UIColor.white {
        didSet {
            //sets the tint color to given color
            tintColor = color
            
            draw(self.frame)
        }
    }
    
    @IBInspectable var width: CGFloat = CGFloat(2.0) {
        didSet {
            draw(self.frame)
        }
    }
    
    override func awakeFromNib() {
        
        //sets up the placeholder
        attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: semitransparentWhite])
        
        //makes the TextField background clear
        backgroundColor = UIColor.clear
        
    }
    
    override func draw(_ rect: CGRect) {
        
        //calculate start and end points for the textFields border
        let start = CGPoint(x: rect.minX, y: rect.maxY)
        let end = CGPoint(x: rect.maxX, y: rect.maxY)
        
        //start border at calculated start point, draw line to calculated end point, and set width of the line
        border.move(to: start)
        border.addLine(to: end)
        border.lineWidth = width
        
        //set stroke color to class color defined
        tintColor.setStroke()
        
        //draw the border
        border.stroke()
    }

}
