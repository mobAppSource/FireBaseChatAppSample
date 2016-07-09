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
        //displaying the spinner
        spinner.showWaitingScreen("Fetching users...", bShowText: true, size: CGSizeMake(150, 100))
        FIRDatabase.database().reference().child("users").observeEventType(FIRDataEventType.ChildAdded, withBlock: {
            (snapshots: FIRDataSnapshot) in
            
            if let dict = snapshots.value as? [String: AnyObject]{
                let user = UserModel()
                user.id = snapshots.key
                user.setValuesForKeysWithDictionary(dict)
                self.users.append(user)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                spinner.hideWaitingScreen()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImgUrl = user.profileImageUrl{
            cell.profileImageView.loadImageCacheWithURLString(profileImgUrl)
        }
        
        
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    var messageController: MsgController?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.popToRootViewControllerAnimated(true)
        let selectedUser = self.users[indexPath.item]
        messageController?.showChatLogControllerForUser(selectedUser)
    }
    
}
//TableViewCell
class UserCell: UITableViewCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRectMake(64, textLabel!.frame.origin.y - 2, textLabel!.frame.width, textLabel!.frame.height)
        detailTextLabel?.frame = CGRectMake(64, detailTextLabel!.frame.origin.y + 2, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
    }
    
    
    let profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 24
        imgView.layer.masksToBounds = true
        imgView.contentMode = .ScaleAspectFill
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.blueColor().CGColor
          
        return imgView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews()
    {
        addSubview(profileImageView)
        
        //constraints for profile iamge ivew
        profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        profileImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(48).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(48).active = true
        
    }
    
    
    
}
extension NewMsgController{
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}