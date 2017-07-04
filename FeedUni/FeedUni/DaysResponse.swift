//
//  DaysResponse.swift
//  FeedUni
//
//  Created by Gabriele Suerz on 29/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit
import ObjectMapper

class DaysResponse: Mappable {
    var calendar: [Day]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        calendar <- map["month"]
    }
}

class Day: Mappable {
    var dayTimestamp: String?
    var lessons: [Lesson]?
    
    required init?(map: Map){
        
    }
    
    init(day: String, lessonsArray: [Lesson]) {
        dayTimestamp = day
        lessons = lessonsArray
    }
    
    func mapping(map: Map) {
        dayTimestamp <- map["day"]
        lessons <- map["classes"]
    }
}

class Lesson: Mappable {
    var lessonName: String?
    var teacher: String?
    var room: String?
    var lessonDate: String?
    var lessonStart: String?
    var lessonEnd: String?
    var course: String?
    var lessonType: String?
    var lessonArea: Int?
    
    required init?(map: Map){
        
    }
	
	init(){
		
	}
    
    func mapping(map: Map) {
        lessonName <- map["name"]
        teacher <- map["prof"]
        room <- map["class"]        
        lessonDate <- map["date"]
        lessonStart <- map["time_start"]
        lessonEnd <- map["time_end"]
        course <- map["course"]
        lessonType <- map["type"]
        lessonArea <- map["area"]
    }
}
