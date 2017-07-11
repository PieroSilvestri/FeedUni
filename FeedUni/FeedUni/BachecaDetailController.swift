//
//  BachecaDetailController.swift
//  FeedUni
//
//  Created by Andrea Scocchi on 26/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit
import SwiftShareBubbles
import Social

class BachecaDetailController: UIViewController, SwiftShareBubblesDelegate{
    
    var bubbles: SwiftShareBubbles?

    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        bubbles?.show()
    }

    @IBOutlet weak var detailImageImage: UIImageView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailDescLabel: UILabel!
    @IBOutlet weak var detailPriceLabel: UILabel!
    @IBOutlet weak var detailInserzionistaLabel: UILabel!
    @IBOutlet weak var detailDataLabel: UILabel!
    @IBOutlet weak var detailNumberLabel: UILabel!
    @IBOutlet weak var detailEmailLabel: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    
    var detailTitle = ""
    var detailDescription = ""
    var detailPrice = ""
    var detailUser = ""
    var detailData = ""
    var detailImage = ""
    var detailNumber = ""
    var detailEmail = ""
    var detailCategory = 0
    let recognizer = UITapGestureRecognizer()
    var heartFlag = false


    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 171/255, green: 0/255, blue: 3/255, alpha: 1.0) /* #ab0003 */
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white

        detailTitleLabel.text = detailTitle
        detailDescLabel.text = detailDescription
        detailPriceLabel.text = "Prezzo: " + detailPrice + "€"
        detailInserzionistaLabel.text = detailUser
        detailNumberLabel.text = detailNumber
        detailEmailLabel.text = detailEmail
        detailDataLabel.text = "Pubblicato il: " + detailData
        if (detailImage == "")
        {
            detailImageImage.image = #imageLiteral(resourceName: "logoUni.png")
        }
        else {
            let decodedData = Data(base64Encoded: detailImage, options: .ignoreUnknownCharacters)
            if (decodedData != nil){
                let decodedimage = UIImage(data: decodedData!)
                detailImageImage.image = decodedimage
            }
        }
        
        bubbles = SwiftShareBubbles(point: CGPoint(x: view.frame.width / 2, y: view.frame.height / 2), radius: 100, in: view)
        bubbles?.showBubbleTypes = [Bubble.twitter, Bubble.facebook, Bubble.google, Bubble.instagram, Bubble.pintereset, Bubble.whatsapp]
        bubbles?.delegate = self
        
        heartImage.isUserInteractionEnabled = true
        recognizer.addTarget(self, action: "imageTapped")
        heartImage.addGestureRecognizer(recognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        initUI()
    }
    
    
    func initUI(){
        let newsList = RealmQueries.getFavoriteInsertions()
            for item in newsList{
            if(item.title == detailTitle){
                heartFlag = true
                heartImage.image = #imageLiteral(resourceName: "fullHeart")
            }
        }

    }

    // SwiftShareBubblesDelegate
    func bubblesTapped(bubbles: SwiftShareBubbles, bubbleId: Int) {
        if let bubble = Bubble(rawValue: bubbleId) {
            print("\(bubble)")
            switch bubble {
            case .facebook:
                if let composer = SLComposeViewController(forServiceType: SLServiceTypeFacebook){
                    composer.setInitialText(detailTitle)
                    composer.add(detailImageImage.image!)
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
    
    func imageTapped(){
        heartFlag = !heartFlag
        print("image tapped")
        
        if (heartFlag == false)
        {
            heartImage.image = #imageLiteral(resourceName: "emptyHeart")
            
            let newsList = RealmQueries.getFavoriteInsertions()
            
            for item in newsList{
                if(item.title == detailTitle){
                    RealmQueries.deleteInsertion(insertion: item)
                }
            }
            
        }
        else{
            heartImage.image = #imageLiteral(resourceName: "fullHeart")
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "it_IT")
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let data = dateFormatter.date(from: detailData)
            
            let price = Int.init(detailPrice)
            
            let newFavorit = FavoriteInsertion(value:[
                "title": detailTitle,
                "insertionDescription":detailDescription,
                "publisherName": detailUser,
                "publishDate": data,
                "email": detailEmail,
                "phoneNumber": detailNumber,
                "price": price,
                "insertionType": detailCategory
                
            ])
            

            RealmQueries.insertInsertion(insertion: newFavorit)
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
