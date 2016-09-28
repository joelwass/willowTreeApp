//
//  NormalModeVC.swift
//  WillowTreeNames
//
//  Created by Joel Wasserman on 9/21/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

class NormalModeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private let reuseIdentifier = "PhotoCell"
    private let sectionInsets = UIEdgeInsets(top: -50.0, left: 10.0, bottom: 10.0, right: 10.0)
    private var photos = [UIImage]()
    private var dimView:DimView?
    private var correctIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Normal Mode"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.dimView = DimView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        self.view.addSubview(dimView!)
        self.view.bringSubviewToFront(dimView!)
        
        self.loadPhotos(HelperMethods.sharedInstance().getSixRandomValues())
    }
    
    func loadPhotos(randomNums: [Int]) {
        
        self.photos.removeAll()
        correctIndex = Int(arc4random_uniform(UInt32(5)))
        
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            for i in Range(0..<randomNums.count) {
            // dispatch async so we can animate each as they load
            
                if let url = NSURL(string: API.sharedInstance().returnedData![randomNums[i]]["url"].string!) {
                    if let data = NSData(contentsOfURL: url) {
                        self?.photos.append(UIImage(data: data)!)
                    }
                }
                
                if (i == self?.correctIndex) {
                    let solutionName = API.sharedInstance().returnedData![randomNums[i]]["name"].string!
                    self?.questionLabel.text = "Which of the following is \(solutionName)?"
                }
                
                if (i == randomNums.count - 1) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self!.dimView?.removeFromSuperview()
                    })
                    self?.collectionView.reloadData()
                }
            }
        })
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        cell.backgroundColor = UIColor.clearColor()
        
        if photos.indices.contains(indexPath.row) {
            cell.imageView.image = photos[indexPath.row]
        }
        // Configure the cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * 7
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == correctIndex) {
            GlobalStats.SharedInstance.RightGuesses += 1
            
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                let alert = UIAlertController(title: "Correct!", message: "", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "Next Employee", style: .Default, handler: { _ in
                    self?.dimView = DimView(frame: CGRectMake(0,0,self!.view.frame.width,self!.view.frame.height))
                    self?.view.addSubview(self!.dimView!)
                    self?.view.bringSubviewToFront(self!.dimView!)
                    
                    self?.questionLabel.text = "Loading..."
                    self?.loadPhotos(HelperMethods.sharedInstance().getSixRandomValues())
                })
                alert.addAction(OKAction)
                self?.presentViewController(alert, animated: true, completion: nil)
            })
        } else {
            GlobalStats.SharedInstance.WrongGuesses += 1
            
            let cell = self.collectionView.cellForItemAtIndexPath(indexPath)
            cell?.backgroundColor = UIColor.redColor()
            let animationDuration = 0.5
            
            // perform animation to flash image red
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                cell?.backgroundColor = UIColor.blueColor()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
