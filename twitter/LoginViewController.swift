//
//  LoginViewController.swift
//  twitter
//
//  Created by Rajat Bhargava on 9/24/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    @IBOutlet weak var twitterBirdImage: UIImageView!
    
    
    let consumerKey = "EeHTyym25HNc21vjWpuvfIyHv"
    let consuemrSecret = "nnkCGQ2Xz9IQHozWNkiNWRXThdaAhwl0gos3iX0ITXqShv4WW5"
    let baseUrl = "https://api.twitter.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Animat the bird
        animateBird()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateBird(){
        self.twitterBirdImage.transform = CGAffineTransform(scaleX: 5, y: 5)
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: { 
            print("put code here")
            self.twitterBirdImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (isCompleted: Bool) in
            
        }



    }
    
    // MARK: - Login
    
    @IBAction func onLogin(_ sender: Any) {
        
        let twitterClient = TwitterClient.sharedInstance
        twitterClient.login(success: { 
           self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) { (error:Error) in
            print("Error:\(error.localizedDescription)")
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
