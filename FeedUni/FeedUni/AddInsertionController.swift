//
//  AddInsertionController.swift
//  FeedUni
//
//  Created by Reginato James on 26/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddInsertionController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var insertionTitleTxt: UITextField!
    @IBOutlet weak var insertionDescriptionTxt: UITextField!
    @IBOutlet weak var insertionPublisherTxt: UITextField!
    @IBOutlet weak var publisherMailTxt: UITextField!
    @IBOutlet weak var publisherPhoneTxt: UITextField!
    @IBOutlet weak var insertionPriceTxt: UITextField!
    @IBOutlet weak var insertionImage: UIButton!
    
    @IBAction func publishBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhotoBtnPressed(_ sender: UIButton) {
        presentCamera()
    }
    
    var cameraUI: UIImagePickerController! = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.insertionTitleTxt.delegate = self
        self.insertionDescriptionTxt.delegate = self
        self.insertionPublisherTxt.delegate = self
        self.publisherMailTxt.delegate = self
        self.publisherPhoneTxt.delegate = self
        self.insertionPriceTxt.delegate = self
        
        let defaults = UserDefaults.standard
        let premail = defaults.value(forKey: "email") as! String
        self.publisherMailTxt.text = premail
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(AddInsertionController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            cameraUI = UIImagePickerController()
            cameraUI.delegate = self
            cameraUI.sourceType = UIImagePickerControllerSourceType.camera;
            cameraUI.mediaTypes = [kUTTypeImage as String]
            cameraUI.allowsEditing = false
            
            self.present(cameraUI, animated: true, completion: nil)
        }
        else {
            print("Can't open camera")
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if(picker.sourceType == UIImagePickerControllerSourceType.camera) {
            
            //Accedi all'immagine appena presa TODO:Prenderla da file system
            let imageToSave = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
            
            self.insertionImage.setImage(imageToSave, for: .normal)
            
            self.savedImageAlert()
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    func savedImageAlert() {
        let alert:UIAlertView = UIAlertView()
        alert.title = "Ghea ghemo fatta!"
        alert.message = "Immagine salvata"
        alert.delegate = self
        alert.addButton(withTitle: "Ok")
        alert.show()
    }

    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
