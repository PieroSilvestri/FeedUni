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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var heartLogo: UIImageView!
    let recognizer = UITapGestureRecognizer()

    
    var titleText: String = ""
    var date : String = ""
    var imageUrl : String = ""
    var content : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        titleLabel.text = String.init(htmlEncodedString: titleText)
        
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
        
        contentTextView.text = String.init(htmlEncodedString: content)
    }
    
    func heartClicked(){
        print("image tapped")
        
        let newData = DateFormatter.init()
        newData.dateFormat = "EEEE dd-MM-yyyy";
        
        let newFavorite = FavoriteNews(value: [
            "title": titleText,
            "content": content,
            "excerpt": "pace",
            "publishingDate": newData.date(from: date),
            "imageURL": imageUrl
            ])
        RealmQueries.insertNews(post: newFavorite)
        
        heartLogo.image? = UIImage(named: "fullHeart")!;
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
