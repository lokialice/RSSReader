//
//  FeedTableViewCell.swift
//  RSSReader
//
//  Created by Macbook Pro MD102 on 9/7/15.
//  Copyright (c) 2015 Loki. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet var itemimageView: UIImageView!
    @IBOutlet var itemTittlelbl: UILabel!
    @IBOutlet var itemAuthorlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
