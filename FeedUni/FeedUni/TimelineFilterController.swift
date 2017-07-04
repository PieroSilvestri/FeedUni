//
//  FilterCourseController.swift
//  FeedUni
//
//  Created by Gabriele Suerz on 26/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

protocol TimelineFilterDelegate {
    func courseChosen(course: String)
}

class TimelineFilterController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate: TimelineFilterDelegate?
	var courses: [String] = []
	
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.tableFooterView = UIView()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = courses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.courseChosen(course: courses[indexPath.row])
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
