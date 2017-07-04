//
//  UserInsertionsController.swift
//  FeedUni
//
//  Created by Reginato James on 04/07/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class UserInsertionsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mTableView: UITableView!
    var userInsertions: [UserInsertion] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        userInsertions = RealmQueries.getUserInsertions()
        self.mTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.mTableView.dequeueReusableCell(withIdentifier: "bachecaCellUser", for: indexPath) as! BachecaControllerTableViewCell
        let vInsertion = userInsertions[indexPath.row]
        cell.cellPrice.text = vInsertion.publisherName
        cell.cellTitle.text = vInsertion.title
        cell.cellData.text = "\(Date.init())"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInsertions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}