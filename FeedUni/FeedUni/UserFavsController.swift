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
import TimelineTableViewCell

class UserFavsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var postController: UISegmentedControl!
    var favInsertions : [FavoriteInsertion] = []
    var favNews : [FavoriteNews] = []
    var favLesson : [FavoriteLesson] = []
    var selection = 0   //Per preimpostare il tipo di post da visualizzare
    var chosenLesson : FavoriteLesson? = nil
    
    @IBAction func controllerChange(_ sender: UISegmentedControl) {
        setUpController(vSelection: sender.selectedSegmentIndex)
        self.mTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController(vSelection: selection)
        self.mTableView.tableFooterView = UIView()
    }
    
    func setUpController(vSelection: Int) {
        self.postController.selectedSegmentIndex = vSelection
        switch vSelection {
        case 0:
            self.favNews = RealmQueries.getFavoritePosts()
        case 1:
            setLessonCell()
            self.favLesson = RealmQueries.getFavoriteLessons()
        default:
            self.favInsertions = RealmQueries.getFavoriteInsertions()
        }
    }
    
    func setLessonCell() {
        let bundle = Bundle(for: TimelineTableViewCell.self)
        let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
                                             bundle: Bundle(url: nibUrl!)!)
        self.mTableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
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
        default:
            let lesson = self.favLesson[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell",
                                                     for: indexPath) as! TimelineTableViewCell
            let timelinePoint = TimelinePoint()
            let timelineBackColor = UIColor.black
            let timelineFrontColor = UIColor.clear

            cell.timelinePoint = timelinePoint
            cell.timeline.frontColor = timelineFrontColor
            cell.timeline.backColor = timelineBackColor
            cell.titleLabel.text = "\(lesson.lessonStart)"
            cell.descriptionLabel.text = lesson.lessonName
            cell.lineInfoLabel.text = lesson.room

            return cell
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.postController.selectedSegmentIndex == 1 {
            self.performSegue(withIdentifier: "lessonDetailSegue", sender: self.mTableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell" , for: indexPath) as! TimelineTableViewCell)
            self.chosenLesson = self.favLesson[indexPath.row]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsDetailSegue" {
            let dest = segue.destination as! NewsDetailController
            let index = self.mTableView.indexPath(for: sender as! NewsTableViewCell)?.row
            let selectedNews = self.favNews[index!]
            dest.titleText = selectedNews.title
            dest.content = selectedNews.content
            dest.date = "\(selectedNews.publishingDate)"
            dest.imageUrl = selectedNews.imageURL
        } else if segue.identifier == "insertionDetailSegue" {
            let dest = segue.destination as! BachecaDetailController
            let index = self.mTableView.indexPath(for: sender as! BachecaControllerTableViewCell)?.row
            let selectedInsertion = self.favInsertions[index!]
            dest.detailTitle = selectedInsertion.title
            dest.detailDescription = selectedInsertion.insertionDescription
            dest.detailPrice = "\(selectedInsertion.price/100)"
            dest.detailUser = selectedInsertion.publisherName
            dest.detailData = "\(selectedInsertion.publishDate)"
            dest.detailImage = selectedInsertion.image
            dest.detailNumber = selectedInsertion.phoneNumber
            dest.detailEmail = selectedInsertion.email
        } else if segue.identifier == "lessonDetailSegue" {
            let dest = segue.destination as! TimelineDetailController
            let selectedLesson = self.chosenLesson
            let convertedObj = Lesson.init()
            convertedObj.course = selectedLesson?.course
            convertedObj.teacher = selectedLesson?.teacher
            convertedObj.lessonName = selectedLesson?.lessonName
            convertedObj.room = selectedLesson?.room
            convertedObj.lessonDate = "\(selectedLesson?.lessonDate)"
            convertedObj.lessonStart = "\(selectedLesson?.lessonStart)"
            convertedObj.lessonEnd = "\(selectedLesson?.lessonEnd)"
            convertedObj.lessonType = selectedLesson?.lessonType
            convertedObj.lessonArea = selectedLesson?.lessonArea
            dest.selectedLesson = convertedObj
        }
    }
}
