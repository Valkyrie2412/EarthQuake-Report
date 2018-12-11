//
//  TableViewCell.swift
//  EarthQuake
//
//  Created by Hiếu Nguyễn on 11/20/18.
//  Copyright © 2018 Hiếu Nguyễn. All rights reserved.
//

import UIKit

class QuakeReportTableViewCell: UITableViewCell {

    @IBOutlet weak var magLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        magLabel.text = ""
        distanceLabel.text = ""
        dateLabel.text = ""
        placeLabel.text = ""
        timeLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
