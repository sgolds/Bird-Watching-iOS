//
//  ChooseImageAction.swift
//  Bird Watching
//
//  Created by Sten Golds on 11/19/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import Foundation
import UIKit

protocol ChooseImageAction {
    
    //requirement variables for chooseImage function to work properly
    var imagePicker: UIImagePickerController { get set }
    var imageSelected: Bool { get set }
    
    //function that allows user to choose an image, whether from camera roll or by taking one with the camera
    //further defined in chooseImageExt.swift in Extenstions group
    func chooseImage(ForView sender: AnyObject)
}
