//
//  ComposeViewController.swift
//  twitter
//
//  Created by Rajat Bhargava on 9/28/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit

@objc protocol ComposeViewControllerDelegate {
    @objc optional func composeViewController(composeViewController:ComposeViewController, updatedTweet tweet: Tweet)
    
}

class ComposeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    weak var delegate: ComposeViewControllerDelegate?
    
    var replyId: Int?
    var replyUser: User?
    
    let countLabel: UILabel = UILabel(frame: CGRect(x: 225, y: 12, width: 40, height: 20))
    
    let MAX_COUNT = 140

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView?.delegate = self
        loadUserData()
        navConfig()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    @IBAction func onTweet(_ sender: Any) {
        
        // Save the tweet
        let tweetString = tweetTextView.text
//        let user : User?
//        var tweet: Tweet?
        
        //Create a tweet
        
        if (tweetString != "") {
//            tweet = Tweet(user: user, text: tweetString!)
            print("Tweet String: \(tweetString)")
            TwitterClient.sharedInstance.postTweet(tweetText: tweetString!, replyId: replyId, success: { (tweet: Tweet) in
                self.delegate?.composeViewController?(composeViewController: self, updatedTweet: tweet)
                
            }) { (error: Error) in
                print("Error:\(error.localizedDescription)")
            }
            
        } else {
            print("no tweet")
        }

         dismiss(animated: true, completion: nil)
    }
    
    
    // Mark: - TextView Delegate
    func textViewDidChange(_ textView: UITextView) {
        print("I am here")
        let counter = MAX_COUNT - tweetTextView.text.characters.count
        countLabel.text = "\(counter)"
        
    }
    
    // Mark: - Config Navigation
    func navConfig(){
        //Create and add a label with 140
        
        countLabel.text = "\(MAX_COUNT)"
        countLabel.textColor = UIColor.black
        self.navigationController?.navigationBar.addSubview(countLabel)
        
        if replyId != nil {
            tweetButton.title = "REPLY"
        }
        
        if let replyUser = replyUser {
            tweetTextView.text = "\(replyUser.screenname) "
        }
    }
    
    func loadUserData(){
        
        guard let user = User.currentUser else {
            return
        }
        nameLabel.text = user.name
        screennameLabel.text = user.screenname
        
        guard let profileUrl = user.profileUrl else {
            return
        }
        profileImage.setImageWith(profileUrl)
        profileImage.layer.cornerRadius = 25
        profileImage.clipsToBounds = true
        
        
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
