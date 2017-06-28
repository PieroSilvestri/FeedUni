//
//  BachecaControllerTableViewCell.swift
//  FeedUni
//
//  Created by Andrea Scocchi on 21/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class BachecaControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellPrice: UILabel!
    @IBOutlet weak var cellData: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
