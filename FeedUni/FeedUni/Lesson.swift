//
//  Lesson.swift
//  FeedUni
//
//  Created by Gabriele Suerz on 28/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit
import JSONJoy

class Lesson: JSONJoy {
    
    var lessonName = ""
    var teacher = ""
    var room = ""
    var lessonDate: Date!
    var lessonStart: Date!
    var lessonEnd: Date!
    var course = ""
    var lessonType = ""
    var lessonArea = 0
    
    required init(_ decoder: JSONDecoder) throws {
        lessonName = try decoder["name"].get()
        teacher = try decoder["prof"].get()
        room = try decoder["class"].get()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        lessonDate = dateFormatter.date(from: try decoder["date"].get())
        lessonStart = dateFormatter.date(from: try decoder["time_start"].get())
        lessonEnd = dateFormatter.date(from: try decoder["time_end"].get())
        course = try decoder["course"].get()
        lessonType = try decoder["type"].get()
        lessonArea = try decoder["area"].get()
    }
}
