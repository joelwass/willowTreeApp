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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.wrongGuessesCountLabel.text = "\(GlobalStats.SharedInstance.WrongGuesses)"
        self.correctGuessesCountLabel.text = "\(GlobalStats.SharedInstance.RightGuesses)"
        self.averageRatioLabel.text = "\(GlobalStats.SharedInstance.RightGuesses / GlobalStats.SharedInstance.WrongGuesses)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
