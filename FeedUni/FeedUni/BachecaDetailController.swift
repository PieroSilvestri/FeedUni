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
    
    var detailTitle = ""
    var detailDescription = ""
    var detailPrice = ""
    var detailUser = ""
    var detailData = ""
    var detailImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        detailTitleLabel.text = detailTitle
        detailDescLabel.text = detailDescription
        detailPriceLabel.text = detailPrice
        detailInserzionistaLabel.text = detailUser
        detailDataLabel.text = detailData
        let dataDecoded : Data = Data(base64Encoded: detailImage, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        detailImageImage.image = decodedimage

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
