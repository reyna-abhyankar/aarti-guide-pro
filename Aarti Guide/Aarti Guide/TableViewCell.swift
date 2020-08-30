//
//  TableViewCell.swift
//  
//
//  Created by Viren Abhyankar on 6/9/15.
//
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var thumbImage: UIImageView!
    @IBOutlet var devLabel: UILabel!
    @IBOutlet var engLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
