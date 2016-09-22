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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.loadPhotos(self.getSixRandomValues())
        print(API.sharedInstance().returnedData![0]["url"])
    }
    
    func getSixRandomValues() -> [Int] {
        
        var nums = Array(0...API.sharedInstance().returnedData!.count-1)
        var randoms = [Int]()
        
        for _ in 1...6 {
            let index = Int(arc4random_uniform(UInt32(nums.count)))
            randoms.append(nums[index])
            nums.removeAtIndex(index)
        }
        
        return randoms
    }
    
    func loadPhotos(randomNums: [Int]) {
        
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            for i in Range(0..<randomNums.count) {
            // dispatch async so we can animate each as they load
            
                if let url = NSURL(string: API.sharedInstance().returnedData![randomNums[i]]["url"].string!) {
                    if let data = NSData(contentsOfURL: url) {
                        self?.photos.append(UIImage(data: data)!)
                    }
                }
                
                if (i == randomNums.count - 1) {
                    self?.collectionView.reloadData()
                }
            }
        })
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        cell.backgroundColor = .blackColor()
        
        if photos.indices.contains(indexPath.row) {
            cell.imageView.image = photos[indexPath.row]
        }
        // Configure the cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return sectionInsets.left
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
