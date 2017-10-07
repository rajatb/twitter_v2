//
//  TweetCell.swift
//  twitter
//
//  Created by Rajat Bhargava on 9/26/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol TweetCellDelegate {
    @objc optional func tweetCell(tweetCell:TweetCell, tweetTapped:Tweet)
    
}

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetInfo: UILabel!
    @IBOutlet weak var retweetInfoImage: UIImageView!
    @IBOutlet var retweetInfoTopConstraint: NSLayoutConstraint!
    @IBOutlet var profileImageRetweetContraint: NSLayoutConstraint!
    
    var delegate: TweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            guard let user = tweet.user else {
                print("User is nil")
                return
            }
            
           
           descriptionLabel.text = tweet.text
            
            if let url = user.profileUrl {
                profileImage.setImageWith(url)
            }
            nameLabel.text = user.name
            screenNameLabel.text = user.screenname
            retweetCountLabel.text = "\(tweet.retweetCount)"
            favCountLabel.text = "\(tweet.favCount)"
            timeLabel.text = tweet.timeStampFromattedString
            retweetInfo.text = tweet.retweetInfo ?? "No retweeted"
            //show hide retweet
            retweetInfo.isHidden = !tweet.isRetweetInfo
            retweetInfoImage.isHidden = !tweet.isRetweetInfo
            retweetInfoTopConstraint.isActive = tweet.isRetweetInfo
            profileImageRetweetContraint.isActive = tweet.isRetweetInfo
          
            
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 5
        profileImage.clipsToBounds = true
        
        // Add the gesture 
        // The didTap: method will be defined in Step 3 below.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        // Optionally set the number of required taps, e.g., 2 for a double click
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)

    }
    
    func didTap(sender: UITapGestureRecognizer) {
        //let location = sender.location(in: view)
        // User tapped at the point above. Do something with that if you want.
        print("I am tapped")
        
        delegate?.tweetCell?(tweetCell: self, tweetTapped: tweet)
        
        //call prepare to segue
        //imageIndexTappged = sender.view?.tag
        
        //performSegue(withIdentifier: "profileSegue", sender: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
