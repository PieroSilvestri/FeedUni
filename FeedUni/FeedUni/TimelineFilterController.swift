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
	@IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Setting the UI
		self.setGUI()
    }
	
	// MARK: - UI
	
	func setGUI() {
		// Button bar not working
		let rightButton = UIBarButtonItem(
			title: "",
			style: .plain,
			target: self,
			action: #selector(buttonCancelPressed(_:)))
		rightButton.tintColor = .white
		/*self.toolbar.setItems([rightButton], animated: true)
		self.toolbar.layer.borderWidth = 1;
		self.toolbar.layer.borderColor = UIColor(red:0.67, green:0.14, blue:0.15, alpha:1.0) as! CGColor*/
		
		self.tableView.tableFooterView = UIView()
	}
	
	func buttonCancelPressed(_ sender: UIBarButtonItem) {
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
