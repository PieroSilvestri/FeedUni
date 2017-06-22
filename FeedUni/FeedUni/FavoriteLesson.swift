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
    dynamic var lessionName = ""
    dynamic var teacher = ""
    dynamic var room = ""
    dynamic var lessionDate: Date!
    dynamic var lessionStart: Date!
    dynamic var lessionEnd: Date!
    dynamic var course = ""
    dynamic var lessionType = ""
    dynamic var lessionArea = 0
}
