//
//  TweetsViewController.swift
//  twitter
//
//  Created by Rajat Bhargava on 9/26/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit
//import FLEX

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetCellDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    
    let refreshControl = UIRefreshControl()
    
    var tweetTapped: Tweet?
    
    var showMentions: Bool = false

    override func viewDidLoad() {
        
//        FLEXManager.shared().showExplorer()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        showMentions ? getMentionTimeLine() : getHomeTimeLine()
    
        
        // Pull to refresh
        
        refreshControl.addTarget(self, action: #selector(getHomeTimeLine), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - Table View controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    @IBAction func onTapOfImage(_ sender: UITapGestureRecognizer) {
       

        
    }
    
    
    // MARK: - Network
    func getHomeTimeLine(){
        TwitterClient.sharedInstance.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            
        }) { (error: Error) in
            print("Error: \(error.localizedDescription)")
        }

    }
    
    func getMentionTimeLine(){
        TwitterClient.sharedInstance.mentionsTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            
        }) { (error: Error) in
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - Compose View controller
    func composeViewController(composeViewController:ComposeViewController, updatedTweet tweet: Tweet){
        tweets.insert(tweet, at: 0)
        self.tableView.reloadData()
    }
    
    // MARK: - TweetCell delegate
    func tweetCell(tweetCell:TweetCell, tweetTapped:Tweet) {
        // Called from the cell
        //perfom the segue
        self.tweetTapped = tweetTapped
        performSegue(withIdentifier: "profileSegue", sender: self)
    }

    @IBAction func onLogout(_ sender: Any) {
       
        TwitterClient.sharedInstance.logout()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "detailSegue") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![(indexPath?.row)!]
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.tweet = tweet
            
        } else if (segue.identifier == "profileSegue") {
            print("Image clicked segue")
            let profileVC = segue.destination as! ProfileViewController
            
            
            profileVC.user = tweetTapped?.user
            
            
        } else {
            let navigationViewController = segue.destination as! UINavigationController
            let composeViewController = navigationViewController.topViewController as! ComposeViewController
            composeViewController.delegate = self
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
 

}
