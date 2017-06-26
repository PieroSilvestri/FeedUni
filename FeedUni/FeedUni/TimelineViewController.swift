//
//  TimelineViewController.swift
//  FeedUni
//
//  Created by Gabriele Suerz on 21/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit
import TimelineTableViewCell

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var timeTableView: UITableView!
    
    var schedule:[String: [(TimelinePoint, UIColor, String, String, String?, String?)]] = ["0/2017-06-24T00:00:00.000Z":[
        (TimelinePoint(), UIColor.black, "12:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", nil, nil),
        (TimelinePoint(color: UIColor.green, filled: true), UIColor.green, "16:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed doe velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "150 mins", "Apple")
        ], "1/2017-06-25T00:00:00.000Z":[
            (TimelinePoint(), UIColor.lightGray, "08:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "60 mins", nil),
            (TimelinePoint(), backColor: UIColor.clear, "20:00", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", nil, nil)
        ]]
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var courses: [String :[NSDictionary]] = [String:Array<NSDictionary>]()
    var chosenCourse = "I.T.S."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup della cella
        let bundle = Bundle(for: TimelineTableViewCell.self)
        let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
                                             bundle: Bundle(url: nibUrl!)!)
        timeTableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        
        self.timeTableView.estimatedRowHeight = 300
        self.timeTableView.rowHeight = UITableViewAutomaticDimension
        
        // Chiamata orari
        self.getJsonFromUrl(page: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
                    
                    self.spinner.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    //self.timeTableView.reloadData()
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        
    }
    
    // MARK: - TimeTableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.schedule.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var nRows = 0
        for key in self.schedule.keys {
            if(key.contains("\(section)/")){
                guard let sectionData = self.schedule[key] else {
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
        
        for key in self.schedule.keys {
            if(key.contains("\(indexPath.section)/")){
                guard let sectionData = self.schedule[key] else {
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
        self.schedule.keys.forEach { (key) in
            if(key.contains("\(section)/")){
                let c = key.characters
                let separator = c.index(of: "/")!
                name = key[c.index(after: separator)..<key.endIndex]
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: name)
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.dateFormat = "EEE dd-MM-yyyy"
        return dateFormatter.string(from: date!).capitalized
    }
    
    func setCourses(months: [NSDictionary]){
        for days in months {
            let classes = days.object(forKey: "classes") as! [NSDictionary]
            for lesson in classes {
                let course = lesson.object(forKey: "course") as! String
                if(!self.courses.isEmpty){
                    for (key, _) in self.courses {
                        if(self.courses[key] != nil){
                            self.courses[key]!.append(lesson)
                        } else {
                            self.courses[course] = [lesson]
                        }
                    }
                } else {
                    self.courses[course] = [lesson]
                }
            }
        }
    }
    
    func setTimeline(){
        for course in self.courses{
            if course.key == self.chosenCourse {
                for value in course.value{
                    let dateString = value.object(forKey: "date") as! Date
                    print(dateString)
                    /*let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date = dateFormatter.date(from: dateString)
                    dateFormatter.dateFormat = "HH:mm"
                    let newPoint = (TimelinePoint(), UIColor.black, dateFormatter.string(from: date), "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", nil, nil)
                    if(!self.schedule.isEmpty){
                        for (key, _) in self.schedule {
                            if(self.schedule[key] != nil){
                                self.schedule[key]!.append(lesson)
                            } else {
                                self.schedule[dateString] = [lesson]
                            }
                        }
                    } else {
                        self.schedule[dateString] = [lesson]
                    }*/
                }
            }
        }
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
