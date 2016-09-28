//
//  StatsVC.swift
//  WillowTreeNames
//
//  Created by Joel Wasserman on 9/27/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

class StatsVC: UIViewController {

    @IBOutlet weak var wrongGuessesCountLabel: UILabel!
    @IBOutlet weak var correctGuessesCountLabel: UILabel!
    @IBOutlet weak var averageRatioLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.wrongGuessesCountLabel.text = "\(GlobalStats.SharedInstance.WrongGuesses)"
        self.correctGuessesCountLabel.text = "\(GlobalStats.SharedInstance.RightGuesses)"
        
        if (GlobalStats.SharedInstance.WrongGuesses == 0) {
            self.averageRatioLabel.text = "1.0"
        } else {
            self.averageRatioLabel.text = "\((Double(GlobalStats.SharedInstance.RightGuesses) / Double(GlobalStats.SharedInstance.WrongGuesses)).roundToPlaces(3))"
        }
        
        self.navigationController?.navigationBarHidden = false
        
        let ratio = Double(self.averageRatioLabel.text!)
        if (ratio > 0.75) {
            self.feedbackLabel.text = "Keep up the good work lad"
        } else if (ratio > 0.5) {
            self.feedbackLabel.text = "Close, but you need some practice"
        } else {
            self.feedbackLabel.text = "C'mon son... It's just a name game!"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.navigationController?.navigationBar.topItem?.title = "Historical Performance Stats"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
