//
//  LoginController.swift
//  FeedUni
//
//  Created by Andrea Scocchi on 20/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    
    @IBOutlet weak var logoUni: UIImageView!

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailText.leftViewMode = UITextFieldViewMode.always
        emailText.leftView = UIImageView(image: UIImage(named: "imageName"))
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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