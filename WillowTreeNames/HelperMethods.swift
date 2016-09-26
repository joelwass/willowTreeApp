//
//  HelperMethods.swift
//  WillowTreeNames
//
//  Created by Joel Wasserman on 9/26/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

class HelperMethods: NSObject {
    
    private static let singleton = HelperMethods()
    
    class func sharedInstance() -> HelperMethods {
        return singleton
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

}


