//
//  NewMsgController.swift
//  FireChatSample
//
//  Created by Master on 7/3/16.
//  Copyright © 2016 Master. All rights reserved.
//

import UIKit
import Firebase


class NewMsgController: UITableViewController {

    private var cellID = "msgCell"
    
    var users: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        self.tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellID)
        //fetching users from database
        self.fetchingUsers()
        
    }
    //fetching the users from firebase's database
    func fetchingUsers()
    {
        FIRDatabase.database().reference().child("users").observeEventType(FIRDataEventType.ChildAdded,
                                                                                   withBlock: {
                                                                                    (snapshots: FIRDataSnapshot) in
                                                                                    
                                                                                    if let dict = snapshots.value as? [String: AnyObject]{
                                                                                        let user = UserModel()
                                                                                        user.setValuesForKeysWithDictionary(dict)
                                                                                        self.users.append(user)
                                                                                    }
                                                                                    dispatch_async(dispatch_get_main_queue(), { 
                                                                                        self.tableView.reloadData()
                                                                                    })
                                                                                    }, withCancelBlock: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellID)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        cell.textLabel?.text = self.users[indexPath.row].name
        cell.detailTextLabel?.text = self.users[indexPath.row].email
        return cell
    }
    
    
}
//TableViewCell
class UserCell: UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension NewMsgController{
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}