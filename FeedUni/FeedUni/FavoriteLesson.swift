//
//  FavoriteLesson.swift
//  FeedUni
//
//  Created by Reginato James on 21/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteLesson: Object {
    dynamic var lessonName = ""
    dynamic var teacher = ""
    dynamic var room = ""
    dynamic var lessonDate: Date!
    dynamic var lessonStart: Date!
    dynamic var lessonEnd: Date!
    dynamic var course = ""
    dynamic var lessonType = ""
    dynamic var lessonArea = 0
	dynamic var lessonReminder = ""
}
