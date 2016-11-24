//
//  TableViewCell.swift
//  thomaskamps-pset4
//
//  Created by Thomas Kamps on 24-11-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelOutlet: UILabel!
    var id: Int64?
    @IBOutlet weak var doneImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
