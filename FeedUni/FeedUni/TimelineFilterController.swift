//
//  FilterCourseController.swift
//  FeedUni
//
//  Created by Gabriele Suerz on 26/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

// Delegate to report the chosen course to the TimelineController
protocol TimelineFilterDelegate {
    func courseChosen(course: String)
}

class TimelineFilterController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate: TimelineFilterDelegate?
	var courses: [String] = []
	
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Setting the UI
		self.setGUI()
    }
	
	// MARK: - UI
	
	func setGUI() {
		self.tableView.tableFooterView = UIView()
	}
	
	@IBAction func buttonCancelPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Tableview
	
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
		// Changing the course
        delegate?.courseChosen(course: courses[indexPath.row])
    }

}
