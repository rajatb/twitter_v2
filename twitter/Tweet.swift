//
//  Tweet.swift
//  twitter
//
//  Created by Rajat Bhargava on 9/26/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit
import DateToolsSwift

class Tweet: NSObject {
    
    var id: Int?
    var user: User?
    var text: String?
    var timeStamp: Date?
    var timeStampFromattedString: String?
    var retweetCount: Int = 0 //retweet_count
    var favCount: Int = 0 // favorite_count
    var replyCount: Int = 0
    var retweetInfo: String?
    var isRetweetInfo: Bool = false
    var isRetweeted: Bool = false
    var isFavorited: Bool = false
    
    init(user: User, text: String){
        self.user = user
        self.text = text
        timeStamp = Date()
    }

    
    init(dictionary: NSDictionary){
        if let userDictionary = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userDictionary)
        }
        
        id = dictionary["id"] as? Int
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favCount = (dictionary["favourite_count"] as? Int) ?? 0
        replyCount = (dictionary["listed_count"] as? Int) ?? 0
        if let retweetDictionary = dictionary["retweeted_status"] as? NSDictionary {
            if let retweetUserDictionary = retweetDictionary["user"] as? NSDictionary{
                let retweetUser = User(dictionary: retweetUserDictionary)
                retweetInfo = retweetUser.screenname + " retweeted"
                isRetweetInfo = true
            }
        }
        
        isRetweeted = (dictionary["retweeted"] as? Bool) ?? false
        isFavorited = (dictionary["favorited"] as? Bool) ?? false
        
        let timeStampString = dictionary["created_at"] as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        if let timeStampString = timeStampString{
            timeStamp = dateFormatter.date(from: timeStampString)
            timeStampFromattedString = timeStamp?.shortTimeAgoSinceNow
            print("Time Stamp: \(timeStampFromattedString)")
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
    

}
