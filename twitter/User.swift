//
//  User.swift
//  twitter
//
//  Created by Rajat Bhargava on 9/26/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenname: String = "@"
    var profileUrl: URL?
    var tagline: String?
    var dictionary: NSDictionary?
    var id: Int64?
    var followerCount: Int64?
    var tweetsCount: Int64?
    var followingCount: Int64?
    var profileBackgroundImageUrl: URL?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        id = dictionary["id"] as? Int64
        name = dictionary["name"] as? String
        screenname += (dictionary["screen_name"] as? String) ?? ""
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: profileUrlString)
        }
        
        followerCount = (dictionary["followers_count"] as? Int64) ?? 0
        tweetsCount = (dictionary["statuses_count"] as? Int64) ?? 0
        followingCount = (dictionary["favourites_count"] as? Int64) ?? 0
        
        if let profileBackgroundImageString = dictionary["profile_background_image_url_https"] as? String {
            profileBackgroundImageUrl = URL(string: profileBackgroundImageString)
        }

        
        tagline = dictionary["description"] as? String
    }
    
    static let userDidLogoutNotification = "didLogout"
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
            
        }
        
        set(user){
            _currentUser = user
           
            let defaults = UserDefaults.standard
            if let user = user {
                
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
                
            } else {
//                 defaults.set(nil, forKey: "currentUserData")
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()

            
            
        }
    }
}
