//
//  ViewController.swift
//  WillowTreeNames
//
//  Created by Joel Wasserman on 9/21/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var normalModeButton: UIButton!
    @IBOutlet weak var reverseModeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.normalModeButton.layer.cornerRadius = 8
        self.normalModeButton.backgroundColor = UIColor.init(hex:0x71B4BA)
        self.normalModeButton.setTitle("Play Normal Mode", forState: .Normal)
        self.normalModeButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.normalModeButton.layer.shadowOffset = CGSizeMake(2, 2)
        self.normalModeButton.layer.shadowRadius = 3
        self.normalModeButton.layer.shadowOpacity = 1.0
        self.normalModeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.normalModeButton.alpha = 0.0
        
        self.reverseModeButton.layer.cornerRadius = 8
        self.reverseModeButton.backgroundColor = UIColor.init(hex:0x71B4BA)
        self.reverseModeButton.setTitle("Play Reverse Mode", forState: .Normal)
        self.reverseModeButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.reverseModeButton.layer.shadowOffset = CGSizeMake(2, 2)
        self.reverseModeButton.layer.shadowRadius = 3
        self.reverseModeButton.layer.shadowOpacity = 1.0
        self.reverseModeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.reverseModeButton.alpha = 0.0
        
        // load logo image
        if let url = NSURL(string: "http://www.codingacrossamerica.com/img/130312-willowtree-apps/willowtree-apps-logo.png") {
            if let data = NSData(contentsOfURL: url) {
                logoImageView.image = UIImage(data: data)
            }        
        }
        
        // get all of the data from the api and load it for future reference
        API.sharedInstance().getNames() {
            response in
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // hide navigation bar on splash page
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let animationDuration = 0.5
        
        // Fade in the buttons
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.normalModeButton.alpha = 1.0
            self.reverseModeButton.alpha = 1.0
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startNormalModePressed(sender: AnyObject) {
        let normalModeVC = self.storyboard?.instantiateViewControllerWithIdentifier("NormalModeVC") as! NormalModeVC
        self.navigationController?.pushViewController(normalModeVC, animated: true)
    }

    @IBAction func startreverseModePressed(sender: AnyObject) {
        let reverseModeVC = self.storyboard?.instantiateViewControllerWithIdentifier("ReverseModeVC") as! ReverseModeVC
        self.navigationController?.pushViewController(reverseModeVC, animated: true)
    }
    
    @IBAction func viewStatsPressed(sender: AnyObject) {
        let statsVC = self.storyboard?.instantiateViewControllerWithIdentifier("StatsVC") as! StatsVC
        self.navigationController?.pushViewController(statsVC, animated: true)
    }
}

// ui color extension for hex value inputs
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}


