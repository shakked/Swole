//
//  ExerciseCell.swift
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

@objc class ExerciseCell: UITableViewCell {

    @objc @IBOutlet weak var exerciseName: UILabel!
    @objc @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    


}
