//
//  Course.swift
//  FeedUni
//
//  Created by Gabriele Suerz on 28/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class Course {
    
    var courseName: String
    var days: [Day]
    
    init(course: String, and daysArray: [Day]) {
        courseName = course
        days = daysArray
    }

}
