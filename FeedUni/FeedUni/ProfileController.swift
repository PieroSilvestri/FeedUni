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

    @IBAction func LogoutPressed(_ sender: UIBarButtonItem) {
        print("Logout pressed")
        UserDefaults.standard.setValue(false, forKey: "ricordami")
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        }
    }

}
