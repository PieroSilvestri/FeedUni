//
// TimelineViewController.swift
// FeedUni
//
// Created by Gabriele Suerz on 21/06/17.
// Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

import TimelineTableViewCell
import Alamofire
import AlamofireObjectMapper

class TimelineController: UIViewController, UITableViewDelegate, UITableViewDataSource, TimelineFilterDelegate {
    
    @IBOutlet weak var timeTableView: UITableView!
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var courses: [Course] = []
    var chosenCourse = "I.T.S."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup della cella
        self.initCell()
        
        self.initGUI()
        
        // Chiamata orari
        self.getJsonFromUrl(page: 1)
    }
    
    // MARK: - Delegate
    
    func courseChosen(course: String) {
        self.chosenCourse = course
		self.title = course
		self.timeTableView.reloadData()
		self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UI
    
    func initCell() {
        let bundle = Bundle(for: TimelineTableViewCell.self)
        let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
                                             bundle: Bundle(url: nibUrl!)!)
        timeTableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        
        self.timeTableView.estimatedRowHeight = 300
        self.timeTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func initGUI() {
		// Button bar
        let rightButton = UIBarButtonItem(
            title: "Filtra",
            style: .plain,
            target: self,
            action: #selector(buttonFilterPressed(_:)))
        navigationItem.rightBarButtonItem = rightButton
		navigationItem.rightBarButtonItem?.tintColor = .white
		
		self.title = self.chosenCourse
		
		// spinner
        self.spinner.center = self.view.center
        self.spinner.hidesWhenStopped = true
        view.addSubview(self.spinner)
        self.spinner.startAnimating()
		
		// unused cells eliminated
        self.timeTableView.tableFooterView = UIView()
    }
    
    func buttonFilterPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "TimelineFilterSegue", sender: sender)
    }
    
    // MARK: - HttpRequest
    
    func getJsonFromUrl(page: Int){
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let shared = UserDefaults.standard
        if let token = shared.object(forKey: "token") {
            headers["Authorization"] = "Bearer \(token)"
		} else {
			headers["Authorization"] = "Bearer 3252261a-215c-4078-a74d-2e1c5c63f0a1"
		}
		
		Alamofire.request("http://apiunipn.parol.in/V1/timetable", headers: headers).responseObject { (response: DataResponse<DaysResponse>)  in
			
			
			self.setCourses(response: response.result.value!)
			
			self.spinner.stopAnimating()
			self.spinner.isHidden = true
			self.timeTableView.reloadData()
        }
		
    }
    
    // MARK: - TimeTableView
    
	func numberOfSections(in tableView: UITableView) -> Int {
		if let index = self.courses.index(where: { (c) -> Bool in
			c.courseName == self.chosenCourse
		}) {
			guard let sec = self.courses[index].days.count as Int? else {
				return 1
			}
			return sec
		}
		return 1
    }
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let index = self.courses.index(where: { (c) -> Bool in
			c.courseName == self.chosenCourse
		}) {
			guard let rows = self.courses[index].days[section].lessons!.count as Int? else {
				return 0
			}
			return rows
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let index = self.courses.index(where: { (c) -> Bool in
			c.courseName == self.chosenCourse
		}) {
			let dateFormatter = DateFormatter()
			dateFormatter.locale = Locale(identifier: "it_IT")
			dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
			let date = Date(timeIntervalSince1970: (dateFormatter.date(from: self.courses[index].days[section].dayTimestamp!)?.timeIntervalSince1970)!)
			dateFormatter.dateFormat = "EEEE dd-MM-yyyy"
			
			return dateFormatter.string(from: date).capitalized
		}
		return ""
	}
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell",
                                                 for: indexPath) as! TimelineTableViewCell
		if let index = self.courses.index(where: { (c) -> Bool in
			c.courseName == self.chosenCourse
		}) {
			guard let lesson = self.courses[index].days[indexPath.section].lessons?[indexPath.row] else {
				return cell
			}
			
			var timelinePoint = TimelinePoint()
			var timelineBackColor = UIColor.black
			var timelineFrontColor = UIColor.clear
			
			if indexPath.row == (self.courses[index].days[indexPath.section].lessons?.count)! - 1 {
				timelineBackColor = UIColor.clear
				timelinePoint = TimelinePoint(color: UIColor(red: 0.29, green: 0.65, blue: 0.89, alpha: 1.0), filled: true)
			}
			if indexPath.row > 0 {
				timelineFrontColor = UIColor.black
			} else {
				timelinePoint = TimelinePoint(color: UIColor(red: 0.29, green: 0.65, blue: 0.89, alpha: 1.0), filled: true)
			}
			
			let dateFormatter = DateFormatter()
			dateFormatter.locale = Locale(identifier: "it_IT")
			dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
			let date = dateFormatter.date(from: lesson.lessonStart!)
			dateFormatter.dateFormat = "HH:mm"
			
			cell.timelinePoint = timelinePoint
			cell.timeline.frontColor = timelineFrontColor
			cell.timeline.backColor = timelineBackColor
			cell.titleLabel.text = dateFormatter.string(from: date!)
			cell.descriptionLabel.text = lesson.lessonName
			cell.lineInfoLabel.text = lesson.room
		}
		
        return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: "TimelineDetailSegue", sender: tableView.cellForRow(at: indexPath))
	}
	
    // MARK: - Course formatter utils
    
    func setCourses(response: DaysResponse){
        for today in response.calendar! {
            for lesson in today.lessons! {
                if let index = self.courses.index(where: { (c) -> Bool in
                    c.courseName == lesson.course
                }) {
                    let temp = self.courses[index].days
                    if let day = temp.index(where: { (d) -> Bool in
                        d.dayTimestamp == lesson.lessonDate
                    }) {
                        self.courses[index].days[day].lessons?.append(lesson)
                    } else {
                        self.courses[index].days.append(Day(day: lesson.lessonDate!, lessonsArray: [lesson]))
                    }
                } else {
                    self.courses.append(Course(course: lesson.course!, and: [Day(day: lesson.lessonDate!, lessonsArray: [lesson])]))
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "TimelineFilterSegue" {
			let filter = segue.destination as! TimelineFilterController
			filter.delegate = self
			let array = self.courses.map({ (c) -> String in
				return c.courseName
			})
			filter.courses = array
		} else if segue.identifier == "TimelineDetailSegue" {
			let indexPath = self.timeTableView.indexPath(for: sender as! TimelineTableViewCell)!
			let detail = segue.destination as! TimelineDetailController
			if let index = self.courses.index(where: { (c) -> Bool in
				c.courseName == self.chosenCourse
			}) {
				detail.selectedLesson = (self.courses[index].days[indexPath.section].lessons?[indexPath.row])!
			} else {
				
			}
		}
		
    }
	
}

