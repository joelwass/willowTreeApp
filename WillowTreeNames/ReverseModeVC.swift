//
//  ReverseModeVC.swift
//  WillowTreeNames
//
//  Created by Joel Wasserman on 9/21/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

class ReverseModeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var dimView:DimView?
    private var names = [String]()
    private var correctIndex:Int?
    private let reuseIdentifier = "NameCell"
    @IBOutlet weak var questionLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var faceImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.backgroundColor = UIColor.init(hex:0x71B4BA)
        self.tableView.layer.cornerRadius = 8
        self.faceImageView.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Reverse Mode"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.dimView = DimView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        self.view.addSubview(dimView!)
        self.view.bringSubviewToFront(dimView!)
        
        self.loadNames(HelperMethods.sharedInstance().getSixRandomValues())
    }
    
    func loadNames(randomNums: [Int]) {
        
        self.names.removeAll()
        correctIndex = Int(arc4random_uniform(UInt32(5)))
        
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            for i in Range(0..<randomNums.count) {
                // dispatch async so we can animate each as they load
                
                if let name = API.sharedInstance().returnedData![randomNums[i]]["name"].string {
                    self?.names.append(name)
                }
                
                if (i == self?.correctIndex) {
                    if let solutionUrl = NSURL(string: API.sharedInstance().returnedData![randomNums[i]]["url"].string!) {
                        if let data = NSData(contentsOfURL: solutionUrl) {
                            self?.faceImageView.image = UIImage(data: data)!
                        }
                    }
                }
                
                if (i == randomNums.count - 1) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self!.dimView?.removeFromSuperview()
                        self!.questionLabel.text = "Who is this?"
                    })
                    self?.tableView.reloadData()
                }
            }
        })
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath:indexPath) as? NameCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: reuseIdentifier) as? NameCell
        }
        
        if names.indices.contains(indexPath.row) {
            cell?.nameLabel.text = names[indexPath.row]
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        
        if (indexPath.row == correctIndex) {
            GlobalStats.SharedInstance.RightGuesses += 1
            
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                let alert = UIAlertController(title: "Correct!", message: "", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "Next Employee", style: .Default, handler: { _ in
                    self?.dimView = DimView(frame: CGRectMake(0,0,self!.view.frame.width,self!.view.frame.height))
                    self?.view.addSubview(self!.dimView!)
                    self?.view.bringSubviewToFront(self!.dimView!)
                    self!.questionLabel.text = "Loading..."
                    
                    self!.loadNames(HelperMethods.sharedInstance().getSixRandomValues())
                })
                alert.addAction(OKAction)
                self?.presentViewController(alert, animated: true, completion: nil)
                })
        } else {
            GlobalStats.SharedInstance.WrongGuesses += 1
            
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            cell?.contentView.backgroundColor = UIColor.redColor()
            let animationDuration = 0.5
            
            // perform animation to flash image red
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                cell?.contentView.backgroundColor = UIColor.whiteColor()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
