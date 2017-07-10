//
//  AddInsertionController.swift
//  FeedUni
//
//  Created by Reginato James on 26/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire

class AddInsertionController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var insertionTitleTxt: UITextField!
    @IBOutlet weak var insertionDescriptionTxt: UITextField!
    @IBOutlet weak var insertionPublisherTxt: UITextField!
    @IBOutlet weak var publisherMailTxt: UITextField!
    @IBOutlet weak var publisherPhoneTxt: UITextField!
    @IBOutlet weak var insertionPriceTxt: UITextField!
    @IBOutlet weak var insertionImage: UIButton!
    @IBOutlet weak var insertionTypeController: UISegmentedControl!
    
    @IBAction func publishBtnPressed(_ sender: UIButton) {
        if insertionTitleTxt.text != "" && insertionDescriptionTxt.text != "" &&
            insertionPublisherTxt.text != "" &&
            (publisherMailTxt.text != "" || publisherMailTxt.text != "") {
            self.postInserion()
        } else {
            let alert:UIAlertView = UIAlertView()
            alert.title = "Attenzione!"
            alert.message = "Alcuni campi sembrano non essere completi"
            alert.delegate = self
            alert.addButton(withTitle: "Ok")
            alert.show()
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhotoBtnPressed(_ sender: UIButton) {
        presentCamera()
    }
    
    var cameraUI: UIImagePickerController! = UIImagePickerController()
    let newSize = CGSize.init(width: 100.0, height: 100.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.insertionTitleTxt.delegate = self
        self.insertionDescriptionTxt.delegate = self
        self.insertionPublisherTxt.delegate = self
        self.publisherMailTxt.delegate = self
        self.publisherPhoneTxt.delegate = self
        self.insertionPriceTxt.delegate = self
        
        let defaults = UserDefaults.standard
        let premail = defaults.value(forKey: "email")
        if premail != nil {
            publisherMailTxt.text = premail as! String
        }
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(AddInsertionController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    
    //MARK: Metodi per fotocamera
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
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //MARK: metodi di creazione dell'annuncio
    //Conversione oggetto per poter fare il POST
    func insertionToJSON(userInsertion: UserInsertion) -> [String : Any] {
        let mImage = resizeImage(image: (insertionImage.imageView?.image)!)
        return [
            "title" : userInsertion.title,
            "price" : userInsertion.price,
            "image" : UIImagePNGRepresentation(mImage)!.base64EncodedString(options: .lineLength64Characters),
            "email" : userInsertion.email,
            "description" : userInsertion.insertionDescription,
            "phone" : userInsertion.phoneNumber,
            "username" : userInsertion.publisherName,
            "tag_id" : userInsertion.insertionType
        ]
    }
    
    
    //Comprime l'immagine presa da fotocamera per poterla postare online
    func resizeImage(image: UIImage) -> UIImage{
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    //Post dell'annuncio creato
    func postInserion() {
        
        let tempInsertion = UserInsertion(value: ["title" : insertionTitleTxt.text, "insertionDescription": insertionDescriptionTxt.text,
                                                  "publisherName" : insertionPublisherTxt.text, "email" : publisherMailTxt.text,
                                                  "phoneNumber" : publisherPhoneTxt.text, "price" : Int.init(insertionPriceTxt.text!)!*100,
                                                  "publishDate" : Date.init().timeIntervalSince1970, "insertionType" : insertionTypeController.selectedSegmentIndex+1, "image" : "documents/hjb"])
        
        //Post su munsra back end
        let jsonInsertion = insertionToJSON(userInsertion: tempInsertion)
        Alamofire.request("https://backend-feeduni-v1.herokuapp.com/api/v1/posts/add", method: .post, parameters: jsonInsertion, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            response.result.ifSuccess {
                RealmQueries.insertUserInsertion(userInsertion: tempInsertion)
            }
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
        
        //Inserimento in db locale
        RealmQueries.insertUserInsertion(userInsertion: tempInsertion)
        
        //Chiudo la view se tutto va a buon fine
        self.dismiss(animated: true, completion: nil)
    }
}
