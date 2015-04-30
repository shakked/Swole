//
//  ZSSHeaderView.swift
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class ZSSHeaderView: UIView {

    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    var dateButtonPressedBlock : () -> Void = {}
    
    @IBAction func dateButtonPressed(sender: AnyObject) {
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
