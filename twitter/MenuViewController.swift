//
//  MenuViewController.swift
//  hamburgerDemo
//
//  Created by Rajat Bhargava on 10/3/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private var profileVC: UINavigationController!
    private var timelineVC: UIViewController!
    private var mentionsVC: UINavigationController!
    
    var viewControllers: [UIViewController] = []
    
    let data: [String] = ["Profile", "Home Timeline", "Mentions"]
    
    // #6 
    var hamburgerVC: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileVC = storyboard.instantiateViewController(withIdentifier: "profileNavigationController") as! UINavigationController
        let profileVeiewController = profileVC.topViewController as! ProfileViewController
        profileVeiewController.user = User.currentUser
        timelineVC = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationC")
        mentionsVC = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationC") as! UINavigationController
        let mentionsVeiwController = mentionsVC.topViewController as! TweetsViewController
        mentionsVeiwController.showMentions = true
        
        
        viewControllers.append(profileVC)
        viewControllers.append(timelineVC)
        viewControllers.append(mentionsVC)
        
        hamburgerVC.contentVC = timelineVC

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Delegate funcs
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuCell
        cell.colorLabel.text = data[indexPath.row]
        return cell
    }

    
    // #5 Once you click the menu do something
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // #6 Deselect the table
        tableView.deselectRow(at: indexPath, animated: true)
        
        // #7 
        hamburgerVC.contentVC = viewControllers[indexPath.row]
        
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
