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
import SwiftShareBubbles
import Social

class NewsDetailController: UIViewController, SwiftShareBubblesDelegate {
    
    
    var bubbles: SwiftShareBubbles?

    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func sharePressed(_ sender: UIButton) {
        bubbles?.show()
    }
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var heartLogo: UIImageView!
    @IBOutlet weak var textView: UITextView!
    let recognizer = UITapGestureRecognizer()

    
    var titleText: String = ""
    var date : String = ""
    var imageUrl : String = ""
    var content : String = ""
    var postLink : String = ""
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
        
        bubbles = SwiftShareBubbles(point: CGPoint(x: view.frame.width / 2, y: view.frame.height / 2), radius: 100, in: view)
        bubbles?.showBubbleTypes = [Bubble.twitter, Bubble.facebook, Bubble.google, Bubble.instagram, Bubble.pintereset, Bubble.whatsapp]
        bubbles?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let newDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
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
            }
        }
        
        if(heartFlag){
            heartLogo.image = #imageLiteral(resourceName: "fullHeart")
        }else{
            heartLogo.image = #imageLiteral(resourceName: "emptyHeart")
        }
        
        contentTextView.text = String.init(htmlEncodedString: content)
    }
    
    // SwiftShareBubblesDelegate
    func bubblesTapped(bubbles: SwiftShareBubbles, bubbleId: Int) {
        if let bubble = Bubble(rawValue: bubbleId) {
            print("\(bubble)")
            switch bubble {
            case .facebook:
                if let composer = SLComposeViewController(forServiceType: SLServiceTypeFacebook){
                    composer.setInitialText("Look at this great picture!")
                    composer.add(newsImageView.image!)
                    composer.add(URL(string: postLink))
                    present(composer, animated: true)
                }
                break
            case .twitter:
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                    guard let composer = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else { return }
                    composer.setInitialText("Inserisci il testo...")
                    present(composer, animated: true, completion: nil)
                }
                break
            case .whatsapp:
                break
            default:
                break
            }
        } else {
            // custom case
        }
    }
    
    func bubblesDidHide(bubbles: SwiftShareBubbles) {
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
