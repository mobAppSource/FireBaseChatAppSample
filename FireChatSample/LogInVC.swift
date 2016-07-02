//
//  LogInVC.swift
//  FireChatSample
//
//  Created by Master on 7/2/16.
//  Copyright © 2016 Master. All rights reserved.
//

import UIKit
import Firebase

class LogInVC: UIViewController {

    //Login and register segment
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.whiteColor()
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChaged), forControlEvents: .ValueChanged)
        return sc
    }()
    //action of segmentedControl changed
    func handleLoginRegisterChaged()
    {
        let title = loginRegisterSegmentedControl.titleForSegmentAtIndex(loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterBtn.setTitle(title, forState: .Normal)
        
        //change the height of inputsContainerView
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100: 150
        //change the height of nameTextField
        nameTextFieldHeightAnchor?.active = false
        let multiplier: CGFloat = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0: 1/3
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: multiplier)
        nameTextFieldHeightAnchor?.active = true
        //change the height of emailTextField
        emailTextFieldHeightAnchor?.active = false
        let emultiplier: CGFloat = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: emultiplier)
        emailTextFieldHeightAnchor?.active = true
        //change the height of passTextField
        passTextFieldHeightAnchor?.active = false
        let pmultiplier: CGFloat = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3
        passTextFieldHeightAnchor = passwdTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: pmultiplier)
        passTextFieldHeightAnchor?.active = true
    }
    //define the input view
    let inputsContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var loginRegisterBtn: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161, alpha: 1)
        button.setTitle("Register", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        
        button.addTarget(self, action: #selector(LogInVC.actionBtn), forControlEvents: .TouchUpInside)
        return button
    }()
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
        guard let email = emailTextField.text, password = passwdTextField.text else{
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user: FIRUser?, error: NSError?) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    //action for registering
    func actionRegister(){
        guard let email = emailTextField.text, password = passwdTextField.text, name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        print("Email: Password = \(email): \(password)")
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error: NSError?) in
            if error != nil{
                print(error!.localizedDescription)
                
                return
            }
            //Successfully authenticated user
            guard let uid = user?.uid else{
                return
            }
            
            let ref = FIRDatabase.database().referenceFromURL("https://firechatsample-fcdee.firebaseio.com/")
            let userReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil{
                    print(error!.localizedDescription)
                    return
                }
                print("Saved user successfully into FireBase Database")
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
        })
    }
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwdTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.secureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let profileImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "proImg")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hidding keyboard
        self.hideKeyboardWhenTappedAround()
        
        self.view.backgroundColor = UIColor(r: 61, g: 91, b: 151, alpha: 1)
        //displaying input view 
        self.view.addSubview(inputsContainerView)
        //displaying login and register button
        self.view.addSubview(loginRegisterBtn)
        //displaying profile image
        self.view.addSubview(profileImgView)
        //displaying login and register segmentedControl
        self.view.addSubview(loginRegisterSegmentedControl)
        
        //adjusting position on the view
        self.setupInputsContainerView()
        //adjusting button's position on the main view
        self.setupLoginRegisterBtn()
        //adjusting profile image position
        self.setupProfileImgView()
        //adjusting the login and register segmentedcontrol's position
        self.setuploginRegisterSegmentedControl()
        
    }
    //adjusting the login and register segmentedcontrol's position
    func setuploginRegisterSegmentedControl()
    {
        loginRegisterSegmentedControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterSegmentedControl.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -12).active = true
        loginRegisterSegmentedControl.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterSegmentedControl.heightAnchor.constraintEqualToConstant(36).active = true
    }
    //adjusting the imageview position
    func setupProfileImgView()
    {
        profileImgView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profileImgView.bottomAnchor.constraintEqualToAnchor(loginRegisterSegmentedControl.topAnchor, constant: -12).active = true
        profileImgView.widthAnchor.constraintEqualToConstant(150).active = true
        profileImgView.heightAnchor.constraintEqualToConstant(150).active = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passTextFieldHeightAnchor: NSLayoutConstraint?
    //creating the inputview in the center of view
    func setupInputsContainerView()
    {
        //adjust inputscontainer size
        //Must be defined the size after addsubview into the main view
        inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputsContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
//        inputsContainerView.heightAnchor.constraintEqualToConstant(150).active = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraintEqualToConstant(150)
        inputsContainerViewHeightAnchor?.active = true
        //Adding Name textfield
        inputsContainerView.addSubview(nameTextField)
        //adding seperator view
        inputsContainerView.addSubview(seperatorView)
        //adding email textField
        inputsContainerView.addSubview(emailTextField)
        //adding email seperator view
        inputsContainerView.addSubview(emailSeperatorView)
        //adding password textfield
        inputsContainerView.addSubview(passwdTextField)
        
        //define name text field position
        nameTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        nameTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
        nameTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.active = true
        //define seperator view position
        seperatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        seperatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        seperatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        seperatorView.heightAnchor.constraintEqualToConstant(1).active = true
        //define email text field position
        emailTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        emailTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.active = true
        //define email seperator view position
        emailSeperatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        emailSeperatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        emailSeperatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        emailSeperatorView.heightAnchor.constraintEqualToConstant(1).active = true
        //define password text field position
        passwdTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        passwdTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        passwdTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        passTextFieldHeightAnchor = passwdTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        passTextFieldHeightAnchor?.active = true
        
    }
    //adjusting login and register button's position
    func setupLoginRegisterBtn()
    {
        loginRegisterBtn.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterBtn.topAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor, constant: 12).active = true
        loginRegisterBtn.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterBtn.heightAnchor.constraintEqualToConstant(50).active = true
        
        
    }


}
extension LogInVC
{
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}