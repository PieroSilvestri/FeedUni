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
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var indexPage: Int = 1
    var listData = [NSDictionary]()
    var tokenUser: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
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
        let index = tempDate.index(tempDate.startIndex, offsetBy: 10)
        let range = tempDate.startIndex..<index
        
        //let myUrl = URL.init(string: imageUrl)
        
        // Configure the cell...
        if let url = URL(string: tempImage) {
            if let data = NSData(contentsOf: url) {
                
                /*
                cell.imageCell.backgroundColor = UIColor(patternImage: UIImage(data: data as Data)!)
                cell.imageCell.bounds.origin.x = (UIImage(data: data as Data)!.size.width/2) - (cell.imageCell.bounds.size.width/2)
                cell.imageCell.bounds.origin.y = (UIImage(data: data as Data)!.size.height/2) - (cell.imageCell.bounds.size.height/2)
                */
              
                cell.imageView!.image = nil

                
                DispatchQueue.main.async {
                    
                var request = Nuke.Request(url: url)
                request.process(key: ""+url.absoluteString) {
                    return $0.resize(CGSize(width: cell.imageCell.frame.width, height: cell.imageCell.frame.height), fitMode: .crop).maskWithEllipse()
                    self.tableView.reloadData()
                }
                
                 Nuke.loadImage(with: request, into: cell.imageView!)
 
                
               
                
                    /*
                    UIGraphicsBeginImageContext(cell.imageCell.frame.size);
                    UIImage(data: data as Data)?.draw(in: cell.imageCell.bounds);
                    let image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    cell.imageCell.backgroundColor = UIColor(patternImage: image!)
                    */
                }
            }
        }
        cell.titleTextView.text = String.init(htmlEncodedString: tempTitle)
        cell.dateLabel.text =  tempDate.substring(with:range)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "NewsDetaiLSegue", sender: indexPath)
        //self.tableView.allowsSelection = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            // call method to add data to tableView
            self.indexPage += 1
            getJsonFromUrl(page: indexPage)
            print("IndexPage: \(self.indexPage)")
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
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
        
        let shared = UserDefaults.standard
        if let token = shared.object(forKey: "token") {
            self.tokenUser = token as! String
        } else {
            self.tokenUser = "f23996c1-0703-464f-b76f-14ffa7a43b58"
        }
        
        // spinner
        self.customActivityIndicatory(self.view, startAnimate: true)
        
        indexPage = 1
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.tableView.tableFooterView = UIView()
        
        
    }
    
    func getJsonFromUrl(page: Int){
        
        //self.flagDownload = false;
        
        
        let urlString = "http://apiunipn.parol.in/V1/posts/\(page)"
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + self.tokenUser, forHTTPHeaderField: "Authorization")
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
                        
                        //print(self.listData)
                        
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        //let currentTemperatureF = self.listData[0]["id"] as! Int
                        //print(currentTemperatureF)
                        DispatchQueue.main.async {
                            self.customActivityIndicatory(self.view, startAnimate: false)

                            self.tableView.reloadData()
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
                }.resume()
        
        
        
        
    }
    
    // Custom spinner
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
