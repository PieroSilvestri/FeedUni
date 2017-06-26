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
    
    @IBOutlet weak var tableView: UITableView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let tempTitle = tempItem["TITLE"] as! String
        let tempDate = tempItem["DATE"] as! String
        let index = tempDate.index(tempDate.startIndex, offsetBy: 10)
        let range = tempDate.startIndex..<index
        let tempUser = tempItem["USER"] as! String
        cell.cellTitle.text = tempTitle
        cell.cellData.text = tempDate.substring(with:range)
        cell.cellPrice.text = tempUser
        
        return cell
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
            let tempTitle = tempItem["TITLE"] as! String
            let tempDate = tempItem["DATE"] as! String
            let index = tempDate.index(tempDate.startIndex, offsetBy: 10)
            let range = tempDate.startIndex..<index
            destination.detailData = tempDate
            destination.detailUser = tempItem["USER"] as! String
            destination.detailTitle = tempTitle
        }
    }
    

}
