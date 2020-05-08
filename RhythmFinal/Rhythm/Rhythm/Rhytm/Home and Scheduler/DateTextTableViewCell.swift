//
//  DateTextTableViewCell.swift
//  Rhytm
//
//  Created by Ziyuan Li on 4/25/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//

import UIKit


class DateTextTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateText(text: String, date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        
        label.text = text
        timeLabel.text = dateFormatter.string(from: date)
    }

}


