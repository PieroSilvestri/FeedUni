//
//  UserFavsController.swift
//  FeedUni
//
//  Created by Reginato James on 04/07/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit
import Nuke
import NukeToucanPlugin

class UserFavsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var postController: UISegmentedControl!
    var favInsertions : [FavoriteInsertion] = []
    var favNews : [FavoriteNews] = []
    var favLesson : [FavoriteLesson] = []
    var selection = 0   //Per preimpostare il tipo di post da visualizzare

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch selection {
        case 0:
            self.postController.selectedSegmentIndex = selection
            self.favNews = RealmQueries.getFavoritePosts()
        case 1:
            self.postController.selectedSegmentIndex = selection
            self.favLesson = RealmQueries.getFavoriteLessons()
        default:
            self.postController.selectedSegmentIndex = selection
            self.favInsertions = RealmQueries.getFavoriteInsertions()
        }
        
        self.mTableView.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.postController.selectedSegmentIndex {
        case 0:
            let cell = self.mTableView.dequeueReusableCell(withIdentifier: "newsCellFavs", for: indexPath) as! NewsTableViewCell
            let vNews = self.favNews[indexPath.row]
            cell.titleTextView.text = vNews.title
            cell.dateLabel.text = "\(vNews.publishingDate)"
            if let url = URL(string: vNews.imageURL) {
                if let data = NSData(contentsOf: url) {
                    
                    cell.imageView?.image = nil
                    
                    var request = Nuke.Request(url: url)
                    request.process(key: "Avatar") {
                        return $0.resize(CGSize(width: cell.imageCell.frame.width, height: cell.imageCell.frame.height), fitMode: .crop)
                    }
                    
                    Nuke.loadImage(with: request, into: cell.imageCell)
                }
            }
            return cell
        case 2:
            let cell = self.mTableView.dequeueReusableCell(withIdentifier: "insertionCellFavs", for: indexPath) as! BachecaControllerTableViewCell
            let vInsertion = self.favInsertions[indexPath.row]
            cell.cellTitle.text = vInsertion.title
            cell.cellData.text = "\(Date.init())"
            cell.cellPrice.text = vInsertion.publisherName
            return cell
        default: break
            //TODO con libreria lezioni
        }
        return self.mTableView.dequeueReusableCell(withIdentifier: "insertionCellFavs")!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.postController.selectedSegmentIndex {
        case 0:
            return self.favNews.count
        case 2:
            return self.favInsertions.count
        default:
            return self.favLesson.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
