//
//  NewsDetailController.swift
//  FeedUni
//
//  Created by Piero Silvestri on 26/06/2017.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit
import Nuke
import NukeToucanPlugin

class NewsDetailController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var heartLogo: UIImageView!
    @IBOutlet weak var textView: UITextView!
    let recognizer = UITapGestureRecognizer()

    
    var titleText: String = ""
    var date : String = ""
    var imageUrl : String = ""
    var content : String = ""
    var heartFlag: Bool = false
    
    override func viewDidLayoutSubviews() {
        newsImageView.layer.cornerRadius = 0.5 * self.newsImageView.frame.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        //initUI()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initUI()
    }
    
    // MARK: - MY FUNC
    
    
    func initUI(){
        
        heartLogo.isUserInteractionEnabled = true
        
        //this is where we add the target, since our method to track the taps is in this class
        //we can just type "self", and then put our method name in quotes for the action parameter
        recognizer.addTarget(self, action: "heartClicked")
        
        //finally, this is where we add the gesture recognizer, so it actually functions correctly
        heartLogo.addGestureRecognizer(recognizer)
        
        textView.text = String.init(htmlEncodedString: titleText)
        textView.isUserInteractionEnabled = false
        contentTextView.isEditable = false;
        contentTextView.isUserInteractionEnabled = true
        
        dateLabel.text = date
        
        let myUrl = URL.init(string: imageUrl)

        if let data = NSData(contentsOf: myUrl!) {
            
            self.newsImageView?.image = nil
            
            var request = Nuke.Request(url: myUrl!)
            request.process(key: "Avatar") {
                return $0.resize(CGSize(width: self.newsImageView.frame.width, height: self.newsImageView.frame.height))
            }
            
            Nuke.loadImage(with: request, into: self.newsImageView)
            
            newsImageView.isHidden = false
 
        }
        
        let newsList = RealmQueries.getFavoritePosts()
        
        for item in newsList{
            if(item.title == titleText){
                heartFlag = true
                heartLogo.image = #imageLiteral(resourceName: "fullHeart")
            }
        }
        
        contentTextView.text = String.init(htmlEncodedString: content)
    }
    
    func heartClicked(){
        print("image tapped")
        heartFlag = !heartFlag
        
        
        
        
        if (heartFlag == false)
        {
            heartLogo.image = #imageLiteral(resourceName: "emptyHeart")
            
            let newsList = RealmQueries.getFavoritePosts()
            
            for item in newsList{
                if(item.title == titleText){
                    RealmQueries.deleteNews(post: item)
                }
            }
            
        }
        else
        {
            heartLogo.image = #imageLiteral(resourceName: "fullHeart")
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "it_IT")
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let newFavorite = FavoriteNews(value: [
                "title": titleText,
                "content": content,
                "excerpt": "pace",
                "publishingDate": dateFormatter.date(from: date)!,
                "imageURL": imageUrl
                ])
            RealmQueries.insertNews(post: newFavorite)
        }
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
