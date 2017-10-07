//
//  ProfileViewController.swift
//  twitter
//
//  Created by Rajat Bhargava on 10/5/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!

    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var followerCount: UILabel!
    
    
    
    var user: User!
    

    
    var tweets:[Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        profileImg.layer.cornerRadius = 5
        profileImg.clipsToBounds = true
        
        loadUserData()
        getUserTimeline()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.accessoryType = .none
        cell.tweet = tweets[indexPath.row]
        return cell

    }
    
    // MARK: - Network
    func getUserTimeline(){
        TwitterClient.sharedInstance.userTimeLine(user: user, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            //self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            
        }) { (error: Error) in
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    
    
    func loadUserData(){
        tweetCount.text = "\(user.tweetsCount!)"
        followingCount.text = "\(user.followingCount!)"
        followerCount.text = "\(user.followerCount!)"
        if let urlBg = user.profileBackgroundImageUrl {
            backgroundImage.setImageWith(urlBg)
        }
        if let profileUrl = user.profileUrl {
            profileImg.setImageWith(profileUrl)
        }
    
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
