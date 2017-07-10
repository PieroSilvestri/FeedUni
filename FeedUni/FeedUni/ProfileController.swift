//
//  ProfileController.swift
//  FeedUni
//
//  Created by Piero Silvestri on 28/06/2017.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class ProfileController: UITableViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let premail = defaults.value(forKey: "email")
        if (premail as? String != nil) {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "profileCell")
            cell?.textLabel?.text = premail as! String
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lessonSegue" {
            let dest = segue.destination as! UserFavsController
            dest.selection = 1
        } else if segue.identifier == "newsInsertion" {
            let dest = segue.destination as! UserFavsController
            dest.selection = 0
        } else if segue.identifier == "insertionSegue" {
            let dest = segue.destination as! UserFavsController
            dest.selection = 2
        } else if segue.identifier == "logoutSegue" {
            let defaults = UserDefaults.standard
            defaults.setValue(false, forKey: "ricordami")
            defaults.synchronize()
        }
    }

}
