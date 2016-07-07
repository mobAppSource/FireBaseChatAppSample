//
//  LoginVC+handlers.swift
//  FireChatSample
//
//  Created by Master on 7/7/16.
//  Copyright © 2016 Master. All rights reserved.
//

import UIKit
import Firebase

extension LogInVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //action for button
    func actionBtn()
    {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            self.actionLogin()
        }else{
            self.actionRegister()
        }
    }
    //action for login
    func actionLogin(){
        //displaying the spinner
        spinner.showWaitingScreen("Logging in...", bShowText: true, size: CGSizeMake(150, 100))
        guard let email = emailTextField.text, password = passwdTextField.text else{
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user: FIRUser?, error: NSError?) in
            dispatch_async(dispatch_get_main_queue(), {
                spinner.hideWaitingScreen()
            })
            if error != nil{
                let alertView = UIAlertController(title: "Warning", message: error!.description, preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
                print(error?.localizedDescription)
                return
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    //action for registering
    func actionRegister(){
        spinner.showWaitingScreen("Registering...", bShowText: true, size: CGSizeMake(150, 100))
        
        guard let email = emailTextField.text, password = passwdTextField.text, name = nameTextField.text else {
            spinner.hideWaitingScreen()
            let alertView = UIAlertController(title: "Warning", message: "Please complete above", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            print("Form is not valid")
            return
        }
        print("Email: Password = \(email): \(password)")
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error: NSError?) in
            
            if error != nil{
                dispatch_async(dispatch_get_main_queue(), {
                    spinner.hideWaitingScreen()
                })
                print("Error: \(error?.localizedDescription)")
                let alertView = UIAlertController(title: "Warning", message: error!.description, preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
                
                return
            }
            //Successfully authenticated user
            guard let uid = user?.uid else{
                return
            }
            //Upload image into storage
            let imgName = NSUUID().UUIDString + ".png"
            let storageRef = FIRStorage.storage().reference().child("profile_images").child(imgName)
            if let uploadData = UIImagePNGRepresentation(self.profileImgView.image!){
                storageRef.putData(uploadData, metadata: nil, completion: {
                    (metaData, error) in
                    if error != nil{
                        print(error?.localizedDescription)
                        return
                    }
                    if let profileImageUrl = metaData?.downloadURL()?.absoluteString{
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid, values: values)
                    }else{
                        
                    }
                    
                })
            }
        })
    }
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]){
        let ref = FIRDatabase.database().referenceFromURL("https://firechatsample-fcdee.firebaseio.com/")
        let userReference = ref.child("users").child(uid)
        
        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            
            dispatch_async(dispatch_get_main_queue(), {
                spinner.hideWaitingScreen()
            })
            
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            print("Saved user successfully into FireBase Database")
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    func actionSelectProImgView(){
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        presentViewController(imgPicker, animated: true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImgFromPicker: UIImage?
        if let editedImg = info["UIImagePickerControllerEditedImage"]{
            selectedImgFromPicker = editedImg as? UIImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"]{
            selectedImgFromPicker = originalImage as? UIImage
        }
        if let selectedImg = selectedImgFromPicker{
            profileImgView.image = selectedImg
            profileImgView.contentMode = .ScaleAspectFit
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Canceled picker")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
