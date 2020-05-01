//
//  Activity.swift
//  Rhytm
//
//  Created by Ziyuan Li on 4/24/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//

import UIKit

class Activity: NSObject {
    var name: String
    var descrip: String
    var start_time = Date()
    var end_time = Date()
    //var list: [String] = []
    var color: String = ""

    init(myName: String, myDesc: String, myStart: Date, myEnd: Date, myColor: String) {
        self.name = myName
        self.descrip = myDesc
        self.start_time = myStart
        self.end_time = myEnd
        self.color = myColor
        super.init()
    }
}
