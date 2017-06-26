//
//  NewsDetailController.swift
//  FeedUni
//
//  Created by Piero Silvestri on 26/06/2017.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class NewsDetailController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    
    var titleText: String = ""
    var date : String = ""
    var imageUrl : String = ""
    var content : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //initUI()
        // Do any additional setup after loading the view.
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
        
        title = String.init(htmlEncodedString: titleText)
        
        dateLabel.text = date
        
        let myUrl = URL.init(string: imageUrl)

        if let data = NSData(contentsOf: myUrl!) {
            
            /*
            newsImageView.backgroundColor = UIColor(patternImage: UIImage(data: data as Data)!)
            newsImageView.bounds.origin.x = (UIImage(data: data as Data)!.size.width/2) - (newsImageView.bounds.size.width/2)
            newsImageView.bounds.origin.y = (UIImage(data: data as Data)!.size.height/2) - (newsImageView.bounds.size.height/2)
 
            */
             UIGraphicsBeginImageContext(newsImageView.frame.size);
             UIImage(data: data as Data)?.draw(in: newsImageView.bounds);
             let image = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             
             newsImageView.backgroundColor = UIColor(patternImage: image!)
            
            newsImageView.isHidden = false
 
        }
        
        contentTextView.text = String.init(htmlEncodedString: content)
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
