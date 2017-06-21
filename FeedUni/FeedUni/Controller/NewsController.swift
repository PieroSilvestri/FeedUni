//
//  NewsController.swift
//  FeedUni
//
//  Created by Piero Silvestri on 21/06/2017.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class NewsController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    var indexPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - TABLE FUNC
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 666
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
        cell.textLabel?.text = "viva dio"
        return cell
    }
    
    // MARK - MY FUNC
    
    func initUI(){
        
        self.spinner.center = self.view.center
        self.spinner.hidesWhenStopped = true
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(self.spinner)
        
        indexPage = 1
        
        self.spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.tableView.tableFooterView = UIView()
        
        
    }
    
    func getJsonFromUrl(page: Int){
        
        //self.flagDownload = false;
        
        let urlString = "http://www.fogliogoriziano.com/?json=get_posts&count=6&page=\(page)"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    
                    
                    let posts = response["posts"] as! [NSDictionary]
                    for post in posts{
                        //self.listData.append(post)
                    }
                    
                    //print(self.listData)
                    
                    self.spinner.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    //let currentTemperatureF = self.listData[0]["id"] as! Int
                    //print(currentTemperatureF)
                    self.tableView.reloadData()
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
