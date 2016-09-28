//
//  GlobalStats.swift
//  WillowTreeNames
//
//  Created by Joel Wasserman on 9/27/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import Foundation

private let _GlobalStats = GlobalStats()

public class GlobalStats {
    
    struct Constants {
        static let WrongGuesses = "WrongGuesses"
        static let RightGuesses = "RightGuesses"
    }
    
    public class var SharedInstance: GlobalStats {
        return _GlobalStats
    }
    
    public var WrongGuesses:Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(Constants.WrongGuesses)
        }
        set (newWrongGuesses) {
            NSUserDefaults.standardUserDefaults().setInteger(newWrongGuesses, forKey: Constants.WrongGuesses)
        }
    }
    
    public var RightGuesses:Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(Constants.RightGuesses)
        }
        set (newRightGuesses) {
            NSUserDefaults.standardUserDefaults().setInteger(newRightGuesses, forKey: Constants.RightGuesses)
        }
    }
}

