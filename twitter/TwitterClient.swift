//
//  TwitterClient.swift
//  twitter
//
//  Created by Rajat Bhargava on 9/26/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    let consumerKey = "EeHTyym25HNc21vjWpuvfIyHv"
    let consuemrSecret = "nnkCGQ2Xz9IQHozWNkiNWRXThdaAhwl0gos3iX0ITXqShv4WW5"
    let baseUrl = "https://api.twitter.com"
    
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "EeHTyym25HNc21vjWpuvfIyHv", consumerSecret: "nnkCGQ2Xz9IQHozWNkiNWRXThdaAhwl0gos3iX0ITXqShv4WW5") as TwitterClient
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize() // bug in BDBOAuth1Manager needs us to deauthorise
        // #1 get token
        let callbackURL = URL(string: "twitterdemo://oauth")
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: callbackURL, scope: nil, success: {(requestToken: BDBOAuth1Credential?) -> Void in
            print("I should have gotten a token")
            print("Request Token: \(requestToken?.token)")
            // #2 send the user to safari to login
            if let token = requestToken?.token {
                let authorizeUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.open(authorizeUrl, options: [:], completionHandler: nil)
            }
            
        }, failure: { (error: Error?) -> Void in
            print("Got a error:")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL){
        
        print("URL:\(url)")
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user:User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error:Error) in
                print(error.localizedDescription)
                self.loginFailure?(error)
            })
            
            
            
        }, failure: { (error:Error?) in
            self.loginFailure?(error!)
        })
        
    }
    
    func currentAccount(success: @escaping (User)->(), failure: @escaping (Error)->()) {
        //Twiter client get info
        self.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            print("Name: \(user.name)")
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func homeTimeLine(success: @escaping ([Tweet]) ->(), failure: @escaping (Error) ->()) {
        //Twiter client get info
        self.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetsDictionary = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetsDictionary)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
        })
    }
    
    func mentionsTimeLine(success: @escaping ([Tweet]) ->(), failure: @escaping (Error) ->()) {
        //Twiter client get info
        self.get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetsDictionary = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetsDictionary)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
        })
    }

    
    func userTimeLine(user: User, success: @escaping ([Tweet]) ->(), failure: @escaping (Error) ->()) {
        //Twiter client get info
        self.get("1.1/statuses/user_timeline.json?user_id=\(user.id!)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let tweetsDictionary = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetsDictionary)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
        })
    }
    
    
    func postTweet(tweetText: String, replyId: Int?, success: @escaping (Tweet)->(), failure: @escaping (Error)->()){
        
        var param: [String: Any] = ["status": tweetText]
        if let replyId = replyId {
            param["in_reply_to_status_id"] = replyId
        }
        post("1.1/statuses/update.json", parameters: param, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            
            let tweeetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweeetDictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func retweet(tweetId: Int, success: @escaping(Tweet)->(), failure:@escaping (Error) ->()){
        let tweetIdString = "\(tweetId)"
        
        print("1.1/statuses/retweet/\(tweetIdString).json")
        self.post("1.1/statuses/retweet/\(tweetIdString).json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let tweeetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweeetDictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error:Error) in
            failure(error)
        }
        
    }
    
    func unretweet(tweetId: Int, success: @escaping(Tweet)->(), failure:@escaping (Error) ->()){
        self.post("1.1/statuses/unretweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let tweeetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweeetDictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error:Error) in
            failure(error)
        }
        
    }
    
    func favorite(tweetId: Int, success: @escaping(Tweet)->(), failure:@escaping (Error) ->()){
        let tweetIdString = "\(tweetId)"
        
        self.post("1.1/favorites/create.json?id=\(tweetIdString)", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let tweeetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweeetDictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error:Error) in
            failure(error)
        }
        
    }
    
    func unfavorite(tweetId: Int, success: @escaping(Tweet)->(), failure:@escaping (Error) ->()){
        let tweetIdString = "\(tweetId)"
        
        
        self.post("1.1/favorites/destroy.json?id=\(tweetIdString)", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let tweeetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweeetDictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error:Error) in
            failure(error)
        }
        
    }
    

}
