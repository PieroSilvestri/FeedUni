//
//  BachecaDetailController.swift
//  FeedUni
//
//  Created by Andrea Scocchi on 26/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class BachecaDetailController: UIViewController {

    @IBOutlet weak var detailImageImage: UIImageView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailDescLabel: UILabel!
    @IBOutlet weak var detailPriceLabel: UILabel!
    @IBOutlet weak var detailInserzionistaLabel: UILabel!
    @IBOutlet weak var detailDataLabel: UILabel!
    @IBOutlet weak var detailNumberLabel: UILabel!
    @IBOutlet weak var detailEmailLabel: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    
    var detailTitle = ""
    var detailDescription = ""
    var detailPrice = ""
    var detailUser = ""
    var detailData = ""
    var detailImage = ""
    var detailNumber = ""
    var detailEmail = ""
    let recognizer = UITapGestureRecognizer()
    var heartFlag = false


    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 171/255, green: 0/255, blue: 3/255, alpha: 1.0) /* #ab0003 */
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white

        detailTitleLabel.text = detailTitle
        detailDescLabel.text = detailDescription
        detailPriceLabel.text = "Prezzo: " + detailPrice + "€"
        detailInserzionistaLabel.text = detailUser
        detailNumberLabel.text = detailNumber
        detailEmailLabel.text = detailEmail
        detailDataLabel.text = "Pubblicato il: " + detailData
        if (detailImage == "")
        {
            detailImageImage.image = #imageLiteral(resourceName: "logoUni.png")
        }
        else {
            let decodedData = Data(base64Encoded: detailImage, options: .ignoreUnknownCharacters)
            if (decodedData != nil){
                let decodedimage = UIImage(data: decodedData!)
                detailImageImage.image = decodedimage
            }
        }
        
        
        heartImage.isUserInteractionEnabled = true
        recognizer.addTarget(self, action: "imageTapped")
        heartImage.addGestureRecognizer(recognizer)
        if (heartFlag == false)
        {
            heartImage.image = #imageLiteral(resourceName: "emptyHeart")
            
        }
        else
        {
            heartImage.image = #imageLiteral(resourceName: "fullHeart")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        initUI()
    }
    
    
    func initUI(){
        
    }

    
    func imageTapped(gesture: UITapGestureRecognizer){
        heartFlag = !heartFlag
        print("image tapped")

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
