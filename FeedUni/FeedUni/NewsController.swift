//
//  NewsController.swift
//  FeedUni
//
//  Created by Piero Silvestri on 21/06/2017.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//
import Nuke
import NukeToucanPlugin
import UIKit

class NewsController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    var indexPage: Int = 1
    var listData = [NSDictionary]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        // Do any additional setup after loading the view.
        getJsonFromUrl(page: indexPage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    

    // MARK - TABLE FUNC
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        let tempItem = self.listData[indexPath.row] as NSDictionary
        let tempImage = tempItem["media"] as! String
        let tempTitle = tempItem["title"] as! String
        let tempDate = tempItem["pub_date"] as! String
        
        //let myUrl = URL.init(string: imageUrl)
        
        // Configure the cell...
        if let url = URL(string: tempImage) {
            if let data = NSData(contentsOf: url) {
                
                /*
                cell.imageCell.backgroundColor = UIColor(patternImage: UIImage(data: data as Data)!)
                cell.imageCell.bounds.origin.x = (UIImage(data: data as Data)!.size.width/2) - (cell.imageCell.bounds.size.width/2)
                cell.imageCell.bounds.origin.y = (UIImage(data: data as Data)!.size.height/2) - (cell.imageCell.bounds.size.height/2)
                */
                
                cell.imageView?.image = nil
                
                var request = Nuke.Request(url: url)
                request.process(key: "Avatar") {
                    return $0.resize(CGSize(width: cell.imageCell.frame.width, height: cell.imageCell.frame.height), fitMode: .crop)
                }
                
                 Nuke.loadImage(with: request, into: cell.imageCell)
                
                    /*
                    UIGraphicsBeginImageContext(cell.imageCell.frame.size);
                    UIImage(data: data as Data)?.draw(in: cell.imageCell.bounds);
                    let image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    cell.imageCell.backgroundColor = UIColor(patternImage: image!)
                    */
                
                
            }
        }
        cell.titleTextView.text = String.init(htmlEncodedString: tempTitle)
        cell.dateLabel.text = tempDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "NewsDetaiLSegue", sender: indexPath)
        //self.tableView.allowsSelection = false
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "NewsDetailSegue"){
            let detail = segue.destination as! NewsDetailController
            let index = self.tableView.indexPath(for: sender as! NewsTableViewCell)?.row
            let tempItem = self.listData[index!]
            detail.titleText = tempItem["title"] as! String
            detail.date = tempItem["createdAt"] as! String
            detail.imageUrl = tempItem["media"] as! String
            detail.content = tempItem["content"] as! String
            
        }
    }
    
    // MARK - MY FUNC
    
    func initUI(){
        
        self.spinner.center = self.view.center
        self.spinner.hidesWhenStopped = true
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(self.spinner)
        self.tableView.tableFooterView = UIView()
        
        indexPage = 1
        
        self.spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.tableView.tableFooterView = UIView()
        
        
    }
    
    func getJsonFromUrl(page: Int){
        
        //self.flagDownload = false;
        
        
        let urlString = "http://apiunipn.parol.in/V1/posts"
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer 3252261a-215c-4078-a74d-2e1c5c63f0a1", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        
            session.dataTask(with:request) { (data, response, error) in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    do {
                        
                        let response = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        
                        let posts = response["data"] as! [NSDictionary]
                        for post in posts{
                            self.listData.append(post)
                        }
                        
                        print(self.listData)
                        
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        //let currentTemperatureF = self.listData[0]["id"] as! Int
                        //print(currentTemperatureF)
                        DispatchQueue.main.sync {
                            self.spinner.stopAnimating()
                            self.spinner.isHidden = true
                            self.tableView.reloadData()
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
                }.resume()
        
        
        
        
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
