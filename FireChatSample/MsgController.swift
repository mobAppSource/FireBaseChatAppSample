//
//  ViewController.swift
//  FireChatSample
//
//  Created by Master on 7/2/16.
//  Copyright © 2016 Master. All rights reserved.
//

import UIKit
import Firebase

class MsgController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.handleLogOut()
        self.checkUserIsLoggedIn()
        let navImg = UIImage(named: "newMsgIcon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: navImg, style: .Plain, target: self, action: #selector(handleNewMsg))
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .Plain, target: self, action: #selector(MsgController.handleLogOut))
    }
    //action for making new message
    func handleNewMsg()
    {
        let newMsgView = NewMsgController()
        newMsgView.messageController = self
        self.navigationController?.pushViewController(newMsgView, animated: true)
    }
    
    func checkUserIsLoggedIn()
    {
        //displaying the spinner
        spinner.showWaitingScreen("Checking...", bShowText: true, size: CGSizeMake(150, 100))
        //check user logged in
        if FIRAuth.auth()?.currentUser?.uid == nil{
            performSelector(#selector(handleLogOut), withObject: nil, afterDelay: 0)
        }else{
            self.fetchUserAndSetupNavBarTitle()
        }
    }
    //
    func fetchUserAndSetupNavBarTitle(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            // for some reason uid = nil
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEventOfType(FIRDataEventType.Value, withBlock: {
            (snapshot) in
            dispatch_async(dispatch_get_main_queue(), {
                spinner.hideWaitingScreen()
            })
            
            if let dict = snapshot.value as? [String: AnyObject]{
                
                let user = UserModel()
                user.setValuesForKeysWithDictionary(dict)
                self.setupNavBarWithUser(user)
            }
            
            }, withCancelBlock: { (error) in
                print(error.localizedDescription)
        })
    }
    //adding profile image + user name
    func setupNavBarWithUser(user: UserModel){
//        self.navigationItem.title = user.name
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        //add container view
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        //add profile image
        let proImgView = UIImageView()
        proImgView.translatesAutoresizingMaskIntoConstraints = false
        proImgView.contentMode = .ScaleAspectFill
        proImgView.layer.cornerRadius = 15
        proImgView.layer.masksToBounds = true
        proImgView.layer.borderColor = UIColor.blueColor().CGColor
        proImgView.layer.borderWidth = 1
        proImgView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl{
            proImgView.loadImageCacheWithURLString(profileImageUrl)
        }
        containerView.addSubview(proImgView)
        //ios 9
        proImgView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
        proImgView.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        proImgView.widthAnchor.constraintEqualToConstant(30).active = true
        proImgView.heightAnchor.constraintEqualToConstant(30).active = true
        //Add name label
        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        containerView.addSubview(nameLabel)
        
        nameLabel.leftAnchor.constraintEqualToAnchor(proImgView.rightAnchor, constant: 8).active = true
        nameLabel.centerYAnchor.constraintEqualToAnchor(proImgView.centerYAnchor).active = true
        nameLabel.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
        nameLabel.heightAnchor.constraintEqualToAnchor(proImgView.heightAnchor).active = true
        //constratints for container view
        containerView.centerXAnchor.constraintEqualToAnchor(titleView.centerXAnchor).active = true
        containerView.centerYAnchor.constraintEqualToAnchor(titleView.centerYAnchor).active = true
        self.navigationItem.titleView = titleView
        //Add gesture recognizer
//        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatLogController)))
        
    }
    func showChatLogControllerForUser(user: UserModel){
        let layout = UICollectionViewFlowLayout()
        let chatLogController = ChatLogController(collectionViewLayout: layout)
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func handleLogOut()
    {
        do{
            try FIRAuth.auth()?.signOut()
            spinner.hideWaitingScreen()
            let loginView = LogInVC()
            loginView.messageController = self
            presentViewController(loginView, animated: true, completion: nil)
        }catch let logoutError{
            print(logoutError)
            spinner.hideWaitingScreen()
        }
        
        
    }

}
extension MsgController{
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
