//
//  DisplayScheduleTableViewCell.swift
//  Rhytm
//
//  Created by Ziyuan Li on 4/29/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//

import UIKit

class DisplayScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var activityName: UILabel!
    
    @IBOutlet weak var songTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(startingTime: Date, color: String, name: String, title: String){
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        startTime.text = dateFormatter.string(from: startingTime)
        activityName.text = name
        songTitle.text = title
        if (color == ""){
            colorButton.isHidden = true
        }
        else if (color == "blue"){
            colorButton.tintColor = UIColor(red: 29/255, green: 59/255, blue: 210/255, alpha: 1)
        }
        else if (color == "red"){
            colorButton.tintColor = UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        }
        else if (color == "yellow"){
            colorButton.tintColor = UIColor(red: 242/255, green: 252/255, blue: 0, alpha: 1)
        }
    }
}
