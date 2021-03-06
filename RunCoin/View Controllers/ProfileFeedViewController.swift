//
//  FeedViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 5/9/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ProfileFeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [FeedPost]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadFeedData()
        title = "User Profile"
    }
    

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            print("successful logout of firebase")
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: {
                    self.navigationController!.popToRootViewController(animated: true)
                })
            }
            else {
                self.navigationController!.popToRootViewController(animated: true)
            }
        }
        catch {
            print("Error logging out of Firebase.")
        }
    }
    
    func loadFeedData(){
        guard let user = Auth.auth().currentUser else {return}
        let uid = user.uid
        Database.database().reference().child("run_data").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let newPost = FeedPost.transformPost(dict: dict)
                self.fetchUser(uid: newPost.uid!, completed: {
                    self.posts.append(newPost)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func fetchUser(uid: String, completed: @escaping ()-> Void){
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let user = User.transformUser(dict: dict)
                self.users.append(user)
                completed()
            }
        }
    }
}


extension ProfileFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! ProfileFeedTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
}
