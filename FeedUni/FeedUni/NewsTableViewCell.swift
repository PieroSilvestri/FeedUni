//
//  NewsTableViewCell.swift
//  FeedUni
//
//  Created by Piero Silvestri on 22/06/2017.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var imageCell: UIImageView!
    
    @IBAction func deleteClicked(_ sender: UIButton) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    var onButtonTapped : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
