//
//  BachecaController.swift
//  FeedUni
//
//  Created by Andrea Scocchi on 21/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class BachecaController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var listData = [NSDictionary]()
    var heartFlag = false
    
    @IBOutlet weak var tableView: UITableView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.getJsonFromUrl()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Func
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bachecaCell", for: indexPath) as! BachecaControllerTableViewCell
        let tempItem = self.listData[indexPath.row] as NSDictionary
        cell.selectionStyle = .none
        
        var tempTitle = ""
        if (tempItem["TITLE"] is NSNull)
        {
            tempTitle = " Titolo non disponibile"
        } else {
            tempTitle = tempItem["TITLE"] as! String
        }

        var tempDate = ""
        if (tempItem["DATE"] is NSNull)
        {
            tempDate = "Data non disponibile"
        }else {
            tempDate = tempItem["DATE"] as! String
        }
        let index = tempDate.index(tempDate.startIndex, offsetBy: 10)
        let range = tempDate.startIndex..<index
        
        var tempUser = ""
        if (tempItem["USER"] is NSNull)
        {
            tempUser = "Utente non disponibile"
        } else {
            tempUser = tempItem["USER"] as! String
        }
        
        var tempImage = ""
        if (tempItem["IMAGE"] is NSNull)
        {
            tempImage = ""
            cell.cellImage.image = #imageLiteral(resourceName: "logoUni.png")
        } else {
            tempImage = tempItem["IMAGE"] as! String

                /*
                let dataDecoded : Data = Data(base64Encoded: tempImage, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                cell.cellImage.image = decodedimage 
                */
        }

        cell.cellTitle.text = tempTitle
        cell.cellData.text = tempDate.substring(with:range)
        cell.cellPrice.text = tempUser
        
        /*
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("imageTapped:")))
        cell.cellHeart.addGestureRecognizer(tapGesture)
        cell.cellHeart.isUserInteractionEnabled = true
        if (heartFlag == false)
        {
            cell.cellHeart.image = #imageLiteral(resourceName: "emptyHeart")
        }
        else
        {
            cell.cellHeart.image = #imageLiteral(resourceName: "fullHeart")
        }
        */
        
        return cell
    }
    
    
    func imageTapped(gesture: UITapGestureRecognizer){
        heartFlag = !heartFlag
    }
    
    
    func getJsonFromUrl(){
        
        //self.flagDownload = false;
        
        let urlString = "http://backend-feeduni-v1.herokuapp.com/api/v1/posts/"
        
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    
                    
                    let posts = response["body"] as! [NSDictionary]
                    for post in posts{
                        self.listData.append(post)
                    }
                    
                    print(self.listData)
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    //let currentTemperatureF = self.listData[0]["id"] as! Int
                    //print(currentTemperatureF)
                    DispatchQueue.main.sync {
                        self.tableView.reloadData()
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "InseptionDetailSegue"){
            let destination = segue.destination as! BachecaDetailController
            let indexRow = self.tableView.indexPath(for: sender as! BachecaControllerTableViewCell)?.row
            
            let tempItem = self.listData[indexRow!] as NSDictionary
            
            
            var tempTitle = ""
            if (tempItem["TITLE"] is NSNull)
            {
                tempTitle = "Titolo non disponibile"
            } else {
                tempTitle = tempItem["TITLE"] as! String
            }
            
            
            var tempDesc = ""
            if (tempItem["DESCRIPTION"] is NSNull)
            {
                tempDesc = "Descrizione non disponibile"
            } else {
                tempDesc = tempItem["DESCRIPTION"] as! String
            }
            
            
            var tempUser = ""
            if (tempItem["USER"] is NSNull)
            {
                tempUser = "Utente non disponibile"
            } else {
                tempUser = tempItem["USER"] as! String
            }
            
            
            var tempPrice = 0
            if (tempItem["PRICE"] is NSNull)
            {
                tempPrice = 0
            } else {
                tempPrice = tempItem["PRICE"] as! Int
            }
            
            
            var tempDate = ""
            if (tempItem["DATE"] is NSNull)
            {
                tempDate = "Data non disponibile"
            }else {
                tempDate = tempItem["DATE"] as! String
            }
            let index = tempDate.index(tempDate.startIndex, offsetBy: 10)
            let range = tempDate.startIndex..<index
            
            
            var tempImage = ""
            if (tempItem["IMAGE"] is NSNull)
            {
                tempImage = ""
            } else {
                tempImage = tempItem["IMAGE"] as! String
            }


            
            destination.detailImage = tempImage
            destination.detailData = tempDate.substring(with:range)
            destination.detailUser = tempUser
            destination.detailDescription = tempDesc
            destination.detailTitle = tempTitle
            destination.detailPrice = "\(tempPrice)"
            
        }
    }
    
    
    
    

}
