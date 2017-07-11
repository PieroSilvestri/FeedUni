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
    var listData1 = [NSDictionary]()

    private let refreshControl = UIRefreshControl()
    var idCategoria = 5
    var rowsTable = 0
    var privaVolta = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    @IBAction func indexChanged(_ sender: Any) {
        
        switch segmentCtrl.selectedSegmentIndex
        {
        case 0:
            idCategoria = 5
            //getJsonFromUrl()
            listData1 = listData
            self.privaVolta = false
            self.tableView.reloadData()
            break
        case 1:
            idCategoria = 1
            //getJsonFromUrl()
            listData1 = [NSDictionary]()
            for item in listData {
                if(item["TAG_ID"] as! Int == 1){
                    listData1.append(item)
                }
            }
            self.privaVolta = false
            self.tableView.reloadData()
            break
        case 2:
            idCategoria = 2
            //getJsonFromUrl()
            listData1 = [NSDictionary]()
            for item in listData {
                if(item["TAG_ID"] as! Int == 2){
                    listData1.append(item)
                }
            }
            self.privaVolta = false
            self.tableView.reloadData()
            break
        case 3:
            idCategoria = 3
            //getJsonFromUrl()
            listData1 = [NSDictionary]()
            for item in listData {
                if(item["TAG_ID"] as! Int == 3){
                    listData1.append(item)
                }
            }
            self.privaVolta = false
            self.tableView.reloadData()
            break
        case 4:
            idCategoria = 4
            //getJsonFromUrl()
            listData1 = [NSDictionary]()
            for item in listData {
                if(item["TAG_ID"] as! Int == 4){
                    listData1.append(item)
                }
            }
            self.privaVolta = false
            self.tableView.reloadData()
            break
        default:
            break
        }
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.getJsonFromUrl()
        self.customActivityIndicatory(self.view, startAnimate: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        var counter = Int()
        if(self.privaVolta){
            counter = self.listData.count
        }else{
            counter = self.listData1.count
        }
        return counter
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bachecaCell", for: indexPath) as! BachecaControllerTableViewCell
        var tempItem = NSDictionary()
        //let indexMunsra = indexPath.row as! Int
        if(self.privaVolta){
            tempItem = self.listData[indexPath.row] as NSDictionary
        }else{
            tempItem = self.listData1[indexPath.row] as NSDictionary
        }
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
        var imageDecoded = #imageLiteral(resourceName: "logoUni.png")
        
        if (tempItem["IMAGE"] is NSNull)
        {
            tempImage = ""
            cell.cellImage.image = #imageLiteral(resourceName: "logoUni.png")
        } else {
            tempImage = tempItem["IMAGE"] as! String
            let decodedData = Data(base64Encoded: tempImage, options: .ignoreUnknownCharacters)
            if (decodedData != nil){
                let decodedimage = UIImage(data: decodedData!)
                imageDecoded = decodedimage!
            }
        }
        
        var tempCat = 0
        if (tempItem["TAG_ID"] is NSNull)
        {
            tempCat = 0
        } else {
            tempCat = tempItem["TAG_ID"] as! Int
        }
        

        cell.cellImage.image = imageDecoded
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
        self.rowsTable = 0
        
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    
                    
                    let posts = response["body"] as! [NSDictionary]
                    for post in posts{
                            self.listData.append(post)
                            self.rowsTable += 1
                    }
                    
                    print(self.listData)
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    
                    DispatchQueue.main.sync {
                        self.customActivityIndicatory(self.view, startAnimate: false)
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
            
            var tempItem = NSDictionary()
            //let indexMunsra = indexPath.row as! Int
            if(self.privaVolta){
                tempItem = self.listData[indexRow!] as NSDictionary
            }else{
                tempItem = self.listData1[indexRow!] as NSDictionary
            }
            
            
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
            
            var tempNumber = ""
            if (tempItem["PHONE"] is NSNull)
            {
                tempNumber = "Numero non disponibile"
            } else {
                tempNumber = tempItem["PHONE"] as! String
            }
            
            var tempEmail = ""
            if (tempItem["EMAIL"] is NSNull)
            {
                tempEmail = "Email non disponibile"
            } else {
                tempEmail = tempItem["EMAIL"] as! String
            }
            
            var tempCat = 0
            if (tempItem["TAG_ID"] is NSNull)
            {
                tempCat = 0
            } else {
                tempCat = tempItem["TAG_ID"] as! Int
            }
            
            destination.detailImage = tempImage
            destination.detailData = tempDate.substring(with:range)
            destination.detailUser = tempUser
            destination.detailDescription = tempDesc
            destination.detailTitle = tempTitle
            destination.detailPrice = "\(tempPrice)"
            destination.detailEmail = tempEmail
            destination.detailNumber = tempNumber
            destination.detailCategory = tempCat
        }
    }
    
    func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
        let mainContainer: UIView = UIView(frame: viewContainer.frame)
        mainContainer.center = viewContainer.center
        mainContainer.backgroundColor = UIColor.black
        // mainContainer.backgroundColor = UIColor.init(coder: 0xFFFFFF)
        mainContainer.alpha = 0.5
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.backgroundColor = UIColor.lightGray
        //viewBackgroundLoading.backgroundColor = UIColor.init(netHex: 0x444444)
        viewBackgroundLoading.alpha = 0.5
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        if startAnimate!{
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            viewContainer.addSubview(mainContainer)
            activityIndicatorView.startAnimating()
        }else{
            for subview in viewContainer.subviews{
                if subview.tag == 789456123{
                    subview.removeFromSuperview()
                }
            }
        }
        return activityIndicatorView
    }


}
