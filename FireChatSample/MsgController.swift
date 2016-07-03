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
        self.navigationController?.pushViewController(newMsgView, animated: true)
    }
    
    func checkUserIsLoggedIn()
    {
        //check user logged in
        if FIRAuth.auth()?.currentUser?.uid == nil{
            performSelector(#selector(handleLogOut), withObject: nil, afterDelay: 0)
        }else{
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEventOfType(FIRDataEventType.Value, withBlock: {
                (snapshot: FIRDataSnapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject]{
                    self.navigationItem.title = dict["name"] as? String
                }
                
                
                }, withCancelBlock: nil)
            
        }
    }
    func handleLogOut()
    {
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        let loginView = LogInVC()
        presentViewController(loginView, animated: true, completion: nil)
    }

}
extension MsgController{
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
