//
//  DimView.swift
//  WillowTreeNames
//
//  Created by Joel Wasserman on 9/27/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

class DimView: UIView {
    
    var loadingIndicator:UIActivityIndicatorView?
    
    deinit {
        //print("deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadingIndicator = UIActivityIndicatorView()
        loadingIndicator?.activityIndicatorViewStyle = .WhiteLarge
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        loadingIndicator!.center = CGPointMake(frame.width/2, frame.height/2)
        loadingIndicator!.startAnimating()
        self.addSubview(loadingIndicator!)
        self.bringSubviewToFront(loadingIndicator!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

