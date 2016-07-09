//
//  ChatLogController.swift
//  FireChatSample
//
//  Created by MacOS on 7/8/16.
//  Copyright © 2016 Master. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var user: UserModel?{
        didSet{
            navigationItem.title = user?.name
        }
    }
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter messages..."
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "Chat Logs"
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        //adding input window at the bottom of screen
        setupInputWindow()
        
        
    }
    //adding message input window
    func setupInputWindow()
    {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.backgroundColor = UIColor.redColor()
        
        view.addSubview(containerView)
        
        //constraints
        containerView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        containerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        containerView.heightAnchor.constraintEqualToConstant(50).active = true
        
        //add send button
        let sendBtn = UIButton(type: .System)
        sendBtn.setTitle("Send", forState: .Normal)
        sendBtn.addTarget(self, action: #selector(actionSend), forControlEvents: .TouchUpInside)
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendBtn)
        //constraints
        sendBtn.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
        sendBtn.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        sendBtn.widthAnchor.constraintEqualToConstant(80).active = true
        sendBtn.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
        //add textfield
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 8).active = true
        inputTextField.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        inputTextField.rightAnchor.constraintEqualToAnchor(sendBtn.leftAnchor).active = true
        inputTextField.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
        //add Seperator view
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor.blackColor()
        
        containerView.addSubview(seperatorView)
        seperatorView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
        seperatorView.topAnchor.constraintEqualToAnchor(containerView.topAnchor).active = true
        seperatorView.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor).active = true
        seperatorView.heightAnchor.constraintEqualToConstant(1).active = true
    
        
    }
    func actionSend(){
        print(inputTextField.text!)
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toID = user!.id!
        let fromID = FIRAuth.auth()!.currentUser!.uid
        let timeStamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toID": toID, "fromID": fromID, "timestamp": timeStamp]
        childRef.updateChildValues(values)
        inputTextField.text = ""
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        actionSend()
        return true
    }
    
    
    
    
    
    
    
    
    
}
extension ChatLogController{
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}