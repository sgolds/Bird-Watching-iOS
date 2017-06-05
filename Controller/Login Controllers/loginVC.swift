//
//  ViewController.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/13/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import UIKit
import Firebase

class loginVC: UIViewController {
    
    //references to the TextFields created in the storyboard
    @IBOutlet weak var emailTF: underlinedWhiteTF!
    @IBOutlet weak var passwordTF: underlinedWhiteTF!
    
    override func viewWillAppear(_ animated: Bool) {
        //if the application has a user's email associated with this device
        //i.e. if the user created an account on this device
        //get the email and fill in the email TextField, so the user does not need to type in their email
        if let email = UserDefaults.standard.value(forKey: KEY_USER_EMAIL) as? String {
            self.emailTF.text = email
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
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    /**
     * @name logInPressed
     * @desc logs the user in, is connected to the log in button in the storyboard
     * @param AnyObject sender - sender of the action
     * @return void
     */
    @IBAction func logInPressed(sender: AnyObject) {
        
        
        if let email = emailTF.text, email != "", let pwd = passwordTF.text, pwd != "" { //continues if user has entered information into the email and password TextFields
            
            //signs in with the user provided email and password
            FIRAuth.auth()!.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error != nil { //if error occurs, display alert to inform user an error has occured
                    //self.showErrorAlert(title: "Could not log in", msg: "")
                    self.handleFBError(error: error!)
                    print(error)
                } else { //if no error has occured, segue to logged in portion of the app
                    self.performSegue(withIdentifier: LOGGED_IN_SEGUE, sender: nil)
                }
                
            })
        } else {
            //if the user did not provide an email/password show an alert telling them it is required
            showErrorAlert(title: "Email and Password Required", msg: "Must enter email/password")
        }
    }
    
    /**
     * @name signUpPressed
     * @desc signs up the user, is connected to the sign up button in the storyboard
     * @param AnyObject sender - sender of the action
     * @return void
     */
    @IBAction func signUpPressed(sender: AnyObject) {
        
        if let email = emailTF.text, email != "", let pwd = passwordTF.text, pwd != "" { //continues if user has entered information into the email and password TextFields
            
            //create user in firebase authentication with the provided email and password
            FIRAuth.auth()!.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                
                
                if error != nil {
                    //self.showErrorAlert(title: "Could not create account", msg: "Problem creating account.")
                    self.handleFBError(error: error!)
                } else {
                    //save the created accounts email, so it will show up at the log infor the user in the future
                    UserDefaults.standard.setValue(email, forKey: KEY_USER_EMAIL)
                    
                    //sign in to the newly created account
                    FIRAuth.auth()!.signIn(withEmail: email, password: pwd, completion: { (userFrom, error) in
                        
                        
                        if let user = userFrom {
                            //starting info for the user that will be put into the firebase database
                            let userToInput = ["provider": user.providerID, "email": user.email!]
                            
                            //create user in the firebase database
                            DataService.ds.createFirebaseUser(uid: user.uid, user: userToInput)
                        }
                        
                    })
                    
                    //segue to logged in portion of the app
                    self.performSegue(withIdentifier: LOGGED_IN_SEGUE, sender: nil)
                }
                
            })
            
        } else {
            showErrorAlert(title: "Email and Password Required", msg: "Must enter email/password")
        }
        
    }
    
    /**
     * @name handleFBError
     * @desc investigates the reason for the error, and displays an alert informing the user of the error
     * @param Error error - error to handle
     * @return void
     */
    func handleFBError(error: Error) {
        
        if let eCode = FIRAuthErrorCode(rawValue: error._code) { //get the error code, needed in order to investigate meaning of error
            //string to display desired message
            var message = ""
            
            
            switch (eCode) { //switch statement to check if the error is one of the commonplace errors we expect to see
            case .errorCodeInvalidEmail: //if error is invalid email, set error message to inform of invalid email and break switch statement
                message = "Invalid email address"
                break
            case .errorCodeWrongPassword: //if error is wrong password, set error message to inform of wrong password and break switch statement
                message = "Invalid password"
                break
            case .errorCodeEmailAlreadyInUse, .errrorCodeAccountExistsWithDifferentCredential: //if error includes already in use email, set error message to inform of includes already in use email and break switch statement; additionally the 3 r's in second clause are in line with Firebase's code
                message = "Email already in use"
                break
            case .errorCodeUserNotFound: //if error is user not found, set error message to inform of user not found and break switch statement
                message = "User not found"
                break
            default: //if error is not one of the one's tested for, inform user that there was a problem and to try again
                message = "Problem with authentication. Try again."
            }
            
            //display alert do inform user of error, use message gotten from switch statement
            self.showErrorAlert(title: "Error", msg: message)
        }
    }
}

