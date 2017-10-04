//
//  DetailViewController.swift
//  twitter
//
//  Created by Rajat Bhargava on 9/29/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit
import DateToolsSwift

class DetailViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetInfo: UILabel!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favCount: UILabel!
    
    
    
    @IBOutlet weak var retweetInfoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var profielImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    var tweet: Tweet!
    
    @IBOutlet weak var favButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        
        profileImage.layer.cornerRadius = 37.5
        profileImage.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    func reloadData(){
        guard let user = tweet.user else {
            print("User is nil")
            return
        }
        
        nameLabel.text = user.name
        screennameLabel.text = user.screenname
        
        if let url = user.profileUrl {
            profileImage.setImageWith(url)
        }
        retweetInfo.text = tweet.retweetInfo ?? "No retweeted"
        tweetTextLabel.text = tweet.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        
        dateLabel.text = dateFormatter.string(from: tweet.timeStamp!)
        
        favCount.text = "\(tweet.favCount)"
        retweetCount.text = "\(tweet.retweetCount)"
        
        configRetweetButton()
        configFavoriteButton()
        
        
        //constraints
        //show hide retweet
        retweetInfo.isHidden = !tweet.isRetweetInfo
        retweetImage.isHidden = !tweet.isRetweetInfo
        retweetInfoTopConstraint.isActive = tweet.isRetweetInfo
        profielImageTopConstraint.isActive = tweet.isRetweetInfo
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configRetweetButton(){
        retweetCount.textColor = tweet.isRetweeted ? UIColor.blue : UIColor.black
    }
    
    func configFavoriteButton(){
         favCount.textColor = tweet.isFavorited ? UIColor.blue : UIColor.black
    }
    
    @IBAction func onReply(_ sender: Any) {
        self.performSegue(withIdentifier: "replySegue", sender: nil)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let composeViewController = navigationController.topViewController as! ComposeViewController
        composeViewController.replyId = 1
        composeViewController.replyUser = tweet.user
        
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        //Call Retweet function
        tweet.isRetweeted = !tweet.isRetweeted
        tweet.retweetCount = tweet.isRetweeted ? tweet.retweetCount+1 : tweet.retweetCount-1
        retweetCount.text = "\(tweet.retweetCount)"
        configRetweetButton()
        //var success = {(tweet: tweet) in print(tweet)}
        if tweet.isRetweeted {
            TwitterClient.sharedInstance.retweet(tweetId: tweet.id!, success: { (tweet:Tweet) in
                print("retweeted")
            }, failure: { (error:Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance.unretweet(tweetId: tweet.id!, success: { (tweet:Tweet) in
                print("detweeted")
            }, failure: { (error:Error) in
                print(error.localizedDescription)
            })
        }
        
    }
    
    @IBAction func onFav(_ sender: Any) {
        // Call on fav.
        tweet.isFavorited = !tweet.isFavorited
        tweet.favCount = tweet.isFavorited ? tweet.favCount+1 : tweet.favCount-1
        favCount.text = "\(tweet.favCount )"
        configFavoriteButton()
        
        if tweet.isFavorited {
            TwitterClient.sharedInstance.favorite(tweetId: tweet.id!, success: { (tweet:Tweet) in
                print("favorited")
            }, failure: { (error:Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance.unfavorite(tweetId: tweet.id!, success: { (tweet:Tweet) in
                print("unfavorited")
            }, failure: { (error:Error) in
                print(error.localizedDescription)
            })
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
