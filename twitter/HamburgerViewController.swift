//
//  HamburgerViewController.swift
//  hamburgerDemo
//
//  Created by Rajat Bhargava on 10/3/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var leftMarginContrain: NSLayoutConstraint!
    
    
    var orignalLeftMargin: CGFloat!
    
    var menuVC: UIViewController! {
        didSet{
            // #4 Add this so menuView is not nil
            view.layoutIfNeeded()
            menuView.addSubview(menuVC.view)
        }
    }
    
    // # 8
    var contentVC: UIViewController! {
        didSet(oldContentViewController){
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                // will move make nil
                oldContentViewController.willMove(toParentViewController: nil)
                // remove from superview
                oldContentViewController.view.removeFromSuperview()
                // did move make nil
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            // Add this for ViewContent lifecycle
            contentVC.willMove(toParentViewController: self)
            containerView.addSubview(contentVC.view)
            contentVC.didMove(toParentViewController: self
            )
            
            UIView.animate(withDuration: 0.3) { 
                self.leftMarginContrain.constant = 0
//                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            orignalLeftMargin = leftMarginContrain.constant
        } else if sender.state == UIGestureRecognizerState.changed {
            leftMarginContrain.constant = orignalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.ended {
            
            UIView.animate(withDuration: 0.3, animations: { 
                if velocity.x > 0 {
                    //opening
                    self.leftMarginContrain.constant = self.view.frame.size.width - 50
                } else {
                    //closing
                    self.leftMarginContrain.constant = 0
                }
                self.view.layoutIfNeeded()
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
