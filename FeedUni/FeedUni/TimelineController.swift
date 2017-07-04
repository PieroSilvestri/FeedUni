//
//  TimelineViewController.swift
//  FeedUni
//
//  Created by Gabriele Suerz on 21/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit
import TimelineTableViewCell
import JSONJoy

class TimelineController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterCourseDelegate {
    
    @IBOutlet weak var timeTableView: UITableView!
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var courses: [String :[Lesson]] = [:]
    var chosenCourse = "UniTS"
    var timeline: [String: [(TimelinePoint, UIColor, String, String, String?, String?)]] = [:]
    
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
        setTimeline()
        self.timeTableView.reloadData()
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
        let rightButton = UIBarButtonItem(
            title: "Filtra",
            style: .plain,
            target: self,
            action: #selector(buttonFilterPressed(_:)))
        
        navigationItem.rightBarButtonItem = rightButton
        
        self.spinner.center = self.view.center
        self.spinner.hidesWhenStopped = true
        view.addSubview(self.spinner)
        
        self.spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        timeTableView.tableFooterView = UIView()
    }
    
    func buttonFilterPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "filter", sender: sender)
    }
    
    // MARK: - HttpRequest
    
    func getJsonFromUrl(page: Int){
        //self.flagDownload = false;
        
        let urlString = "http://apiunipn.parol.in/V1/timetable"
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer 3252261a-215c-4078-a74d-2e1c5c63f0a1", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    
                    self.setCourses(months: response["month"] as! [NSDictionary])
                    self.setTimeline()
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                } catch let error as NSError {
                    print(error)
                    DispatchQueue.main.sync {
                        self.spinner.stopAnimating()
                        self.spinner.isHidden = true
                        self.timeTableView.reloadData()
                    }
                }
            }
            
            }.resume()
        
    }
    
    // MARK: - TimeTableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.timeline.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var nRows = 0
        for key in self.timeline.keys {
            if(key.contains("\(section)/")){
                guard let sectionData = self.timeline[key] else {
                    return 0
                }
                nRows = sectionData.count
            }
        }
        return nRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell",
                                                 for: indexPath) as! TimelineTableViewCell
        
        for key in self.timeline.keys {
            if(key.contains("\(indexPath.section)/")){
                guard let sectionData = self.timeline[key] else {
                    return cell
                }
                
                let (timelinePoint, timelineBackColor, title, description, lineInfo, thumbnail) = sectionData[indexPath.row]
                var timelineFrontColor = UIColor.clear
                if (indexPath.row > 0) {
                    timelineFrontColor = sectionData[indexPath.row - 1].1
                }
                cell.timelinePoint = timelinePoint
                cell.timeline.frontColor = timelineFrontColor
                cell.timeline.backColor = timelineBackColor
                cell.titleLabel.text = title
                cell.descriptionLabel.text = description
                cell.lineInfoLabel.text = lineInfo
                if let thumbnail = thumbnail {
                    cell.thumbnailImageView.image = UIImage(named: thumbnail)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var name = "Giorno"
        self.timeline.keys.forEach { (key) in
            if key.contains("\(section)/") {
                let c = key.characters
                let separator = c.index(of: "/")!
                name = key[c.index(after: separator)..<key.endIndex]
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: name)
        dateFormatter.dateFormat = "EEE dd-MM-yyyy"
        return dateFormatter.string(from: date!).capitalized
    }
    
    // MARK: - TimeTableView utils
    
    func setCourses(months: [NSDictionary]){
        for days in months {
            let classes = days.object(forKey: "classes") as! [NSDictionary]
            for lesson in classes {
                do {
                    let lessonFormatted = try Lesson(JSONDecoder(lesson))
                    if !self.courses.isEmpty {
                        if self.courses.keys.contains(lessonFormatted.course) {
                            self.courses[lessonFormatted.course]!.append(lessonFormatted)
                        } else {
                            self.courses[lessonFormatted.course] = [lessonFormatted]
                        }
                    } else {
                        self.courses[lessonFormatted.course] = [lessonFormatted]
                    }
                } catch {
                    // print("unable to parse the JSON")
                }
            }
        }
    }
    
    func setTimeline() {
        var newPoint: (TimelinePoint, UIColor, String, String, String?, String?)
        if self.courses[chosenCourse] != nil {
            let course = self.courses[chosenCourse]
            for value in course! {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let day = dateFormatter.string(from: value.lessonDate)
                dateFormatter.dateFormat = "HH:mm"
                
                var point = TimelinePoint()
                newPoint = (point, UIColor.black, dateFormatter.string(from: value.lessonStart), value.lessonName, value.room, nil)
                
                var noKey = true
                if !self.timeline.isEmpty {
                    self.timeline.keys.forEach { (key) in
                        print(key.contains(day))
                        if key.contains(day) {
                            self.timeline[key]!.append(newPoint)
                            noKey = false
                        } else {
                            noKey = true
                        }
                    }
                    if noKey {
                        let k = "\(self.timeline.count)/\(day)"
                        self.timeline[k] = [newPoint]
                    }
                } else {
                    let k = "\(self.timeline.count)/\(day)"
                    self.timeline[k] = [newPoint]
                }
                
                self.timeline[day]?.forEach { (key) in
                    if key.3 == self.timeline[day]?.last?.3 && key.2 == self.timeline[day]?.last?.2 {
                        let c = self.timeline[day]?.removeLast()
                        newPoint = (point, backColor: UIColor.clear, (c?.2)!, (c?.3)!, c?.4, c?.5)
                        self.timeline[day]?.append(newPoint)
                    }
                }
            }
        }
                /*let today = (value.object(forKey: "date") as! String)
                
                let dateString = value.object(forKey: "time_start") as! String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                var noKey = true
                if !self.timeline.isEmpty {
                    self.timeline.keys.forEach { (key) in
                        if key.contains(today) {
                            self.timeline[key]!.append(newPoint)
                            noKey = false
                        } else {
                            noKey = true
                        }
                    }
                    if noKey {
                        let k = "\(self.timeline.count)/\(today)"
                        self.timeline[k] = [newPoint]
                    }
                } else {
                    let k = "\(self.timeline.count)/\(today)"
                    self.timeline[k] = [newPoint]
                }
                
                self.timeline.forEach { (key) in
                    print("------------------")
                    print(key.value == self.timeline[key.key]?.last)
                    /*let c = self.timeline[key]?.removeLast()
                    newPoint = (point, backColor: UIColor.clear, (c?.2)!, (c?.3)!, c?.4, c?.5)
                    self.timeline[key]?.append(newPoint)*/
                }*/
        DispatchQueue.main.async(execute: {
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.timeTableView.reloadData()
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
