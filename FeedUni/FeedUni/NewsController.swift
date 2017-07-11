//
//  NewsController.swift
//  FeedUni
//
//  Created by Piero Silvestri on 21/06/2017.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//
import Alamofire
import Nuke
import NukeToucanPlugin
import Toucan
import UIKit
import AlamofireImage


class NewsController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    //var spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var indexPage: Int = 1
    var listData = [NSDictionary]()
    var tokenUser: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
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
        let imageCache = AutoPurgingImageCache(memoryCapacity: 100 * 1024 * 1024, preferredMemoryUsageAfterPurge: 60 * 1024 * 1024)
        
        if let url = URL(string: tempImage) {
            if NSData(contentsOf: url) != nil {
                cell.imageView!.image = nil
                let sizeOfImage = CGSize(width: cell.imageCell.frame.width, height: cell.imageCell.frame.height)
                if let image = imageCache.image(withIdentifier: url.absoluteString){
                    cell.imageCell.image = Toucan(image: image).resize(sizeOfImage, fitMode: Toucan.Resize.FitMode.crop).maskWithEllipse().image
                } else {
                    Alamofire.request(url).responseImage { response in
                        if let image = response.result.value {
                            cell.imageCell.image = Toucan(image: image).resize(sizeOfImage, fitMode: Toucan.Resize.FitMode.crop).maskWithEllipse().image
                            imageCache.add(image, withIdentifier: url.absoluteString)
                        }
                    }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
            self.indexPage += 1
            getJsonFromUrl(page: indexPage)
            print("IndexPage: \(self.indexPage)")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "NewsDetailSegue"){
            let detail = segue.destination as! NewsDetailController
            let index = self.tableView.indexPath(for: sender as! NewsTableViewCell)?.row
            let tempItem = self.listData[index!]
            detail.titleText = tempItem["title"] as! String
            detail.postLink = tempItem["link"] as! String
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
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.tableView.tableFooterView = UIView()
    }
    
    func getJsonFromUrl(page: Int){
        let urlString = "http://apiunipn.parol.in/V1/posts/\(page)"
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        headers["Authorization"] = "Bearer \(self.tokenUser)"
        
        Alamofire.request(urlString, headers: headers).responseJSON { response  in
            
            self.customActivityIndicatory(self.view, startAnimate: false)
            
            if let json = response.result.value as? NSDictionary{
                for post in (json["data"] as? NSArray)!{
                    self.listData.append((post as? NSDictionary)!)
                }
            }
            self.tableView.reloadData()
        }
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
    
}
