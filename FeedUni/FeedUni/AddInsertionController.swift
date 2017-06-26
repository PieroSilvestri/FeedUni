//
//  AddInsertionController.swift
//  FeedUni
//
//  Created by Reginato James on 26/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class AddInsertionController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var insertionTitleTxt: UITextField!
    @IBOutlet weak var insertionDescriptionTxt: UITextField!
    @IBOutlet weak var insertionPublisherTxt: UITextField!
    @IBOutlet weak var publisherMailTxt: UITextField!
    @IBOutlet weak var publisherPhoneTxt: UITextField!
    @IBOutlet weak var insertionPriceTxt: UITextField!
    
    @IBAction func publishBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.insertionTitleTxt.delegate = self
        self.insertionDescriptionTxt.delegate = self
        self.insertionPublisherTxt.delegate = self
        self.publisherMailTxt.delegate = self
        self.publisherPhoneTxt.delegate = self
        self.insertionPriceTxt.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(AddInsertionController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
