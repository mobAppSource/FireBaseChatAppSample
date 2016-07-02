//
//  ViewController.swift
//  FireChatSample
//
//  Created by Master on 7/2/16.
//  Copyright © 2016 Master. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //check user logged in
        if FIRAuth.auth()?.currentUser?.uid == nil{
            performSelector(#selector(handleLogOut), withObject: nil, afterDelay: 0)
        }
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .Plain, target: self, action: #selector(ViewController.handleLogOut))
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
extension ViewController{
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
