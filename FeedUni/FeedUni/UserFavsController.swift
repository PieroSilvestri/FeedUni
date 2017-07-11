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
    
    let insertionFormatter = DateFormatter()
    
    @IBAction func controllerChange(_ sender: UISegmentedControl) {
        setUpController(vSelection: sender.selectedSegmentIndex)
        self.mTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertionFormatter.locale = Locale(identifier: "it_IT")
        insertionFormatter.timeZone = TimeZone(abbreviation: "UTC")
        insertionFormatter.dateFormat = "dd-MM-yyyy"
        
        navigationController?.navigationBar.tintColor = UIColor.white
        setUpController(vSelection: selection)
        self.mTableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpController(vSelection: self.postController.selectedSegmentIndex)
        self.mTableView.reloadData()
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
            if (self.favNews.count > 0) {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "it_IT")
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let cell = self.mTableView.dequeueReusableCell(withIdentifier: "newsCellFavs", for: indexPath) as! NewsTableViewCell
                let vNews = self.favNews[indexPath.row]
                
                cell.onButtonTapped = {
                    RealmQueries.deleteNews(post: self.favNews[indexPath.row])
                    self.favNews.remove(at: indexPath.row)
                    self.mTableView.reloadData()
                }
                
                cell.titleTextView.text = String.init(htmlEncodedString: vNews.title)
                cell.dateLabel.text = dateFormatter.string(from: vNews.publishingDate)
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
            } else {
                self.mTableView.estimatedRowHeight = 300
                self.mTableView.rowHeight = UITableViewAutomaticDimension
                return self.mTableView.dequeueReusableCell(withIdentifier: "nothingCell", for: indexPath)
            }
        case 2:
            if (self.favInsertions.count > 0) {
                let cell = self.mTableView.dequeueReusableCell(withIdentifier: "insertionCellFavs", for: indexPath) as! BachecaControllerTableViewCell
                let vInsertion = self.favInsertions[indexPath.row]
                
                cell.onButtonTapped = {
                    RealmQueries.deleteInsertion(insertion: self.favInsertions[indexPath.row])
                    self.favInsertions.remove(at: indexPath.row)
                    self.mTableView.reloadData()
                }
                
                var imageDecoded : UIImage? = nil
                print("\n\nimagein profile= \(vInsertion.image)")
                let decodedData = Data(base64Encoded: vInsertion.image, options: .ignoreUnknownCharacters)
                if (decodedData != nil){
                    let decodedimage = UIImage(data: decodedData!)
                    if decodedimage != nil {
                        imageDecoded = decodedimage!
                    }
                }

                cell.cellTitle.text = vInsertion.title
                cell.cellData.text = self.insertionFormatter.string(from: vInsertion.publishDate!)
                cell.cellPrice.text = vInsertion.publisherName
                if imageDecoded != nil {
                    cell.cellImage.image = imageDecoded
                }
                return cell
            } else {
                self.mTableView.estimatedRowHeight = 300
                self.mTableView.rowHeight = UITableViewAutomaticDimension
                return self.mTableView.dequeueReusableCell(withIdentifier: "nothingCell", for: indexPath) as UITableViewCell
            }
        default:
            if (self.favLesson.count > 0) {
                let lesson = self.favLesson[indexPath.row]
                
                // Date formatted in string "DayName 01-01-1970"
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "it_IT")
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                dateFormatter.dateFormat = "EEEE dd-MM-yyyy"
                
                self.mTableView.estimatedRowHeight = 300
                self.mTableView.rowHeight = UITableViewAutomaticDimension
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell",
                                                         for: indexPath) as! TimelineTableViewCell
                
                let timelinePoint = TimelinePoint(color: UIColor(red: 0.29, green: 0.65, blue: 0.89, alpha: 1.0), filled: true)
                let timelineBackColor = UIColor.clear
                let timelineFrontColor = UIColor.clear
                
                cell.timelinePoint = timelinePoint
                cell.timeline.frontColor = timelineFrontColor
                cell.timeline.backColor = timelineBackColor
                cell.titleLabel.text = dateFormatter.string(from: lesson.lessonDate).capitalized
                cell.descriptionLabel.text = lesson.lessonName
                cell.lineInfoLabel.text = lesson.room
                
                return cell
            } else {
                self.mTableView.estimatedRowHeight = 300
                self.mTableView.rowHeight = UITableViewAutomaticDimension
                return self.mTableView.dequeueReusableCell(withIdentifier: "nothingCell", for: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.postController.selectedSegmentIndex {
        case 0:
            if (self.favNews.count > 0) {
                return self.favNews.count
            } else {
                return 1
            }
        case 2:
            if (self.favInsertions.count > 0) {
                return self.favInsertions.count
            } else {
                return 1
            }
        default:
            if (self.favLesson.count > 0) {
                return self.favLesson.count
            } else {
                return 1
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.postController.selectedSegmentIndex == 1 && self.favLesson.count > 0{
            self.chosenLesson = self.favLesson[indexPath.row]
            self.performSegue(withIdentifier: "lessonDetailSegue", sender: self.mTableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell" , for: indexPath) as! TimelineTableViewCell)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsDetailSegue" && self.favNews.count > 0 {
            let dest = segue.destination as! NewsDetailController
            let index = self.mTableView.indexPath(for: sender as! NewsTableViewCell)?.row
            let selectedNews = self.favNews[index!]
            dest.titleText = selectedNews.title
            dest.content = selectedNews.content
            dest.date = insertionFormatter.string(from: selectedNews.publishingDate)
            dest.imageUrl = selectedNews.imageURL
        } else if segue.identifier == "insertionDetailSegue" && self.favInsertions.count > 0 {
            let dest = segue.destination as! BachecaDetailController
            let index = self.mTableView.indexPath(for: sender as! BachecaControllerTableViewCell)?.row
            let selectedInsertion = self.favInsertions[index!]
            dest.detailTitle = selectedInsertion.title
            dest.detailDescription = selectedInsertion.insertionDescription
            dest.detailPrice = "\(selectedInsertion.price/100)"
            dest.detailUser = selectedInsertion.publisherName
            dest.detailData = self.insertionFormatter.string(from: selectedInsertion.publishDate!)
            dest.detailImage = selectedInsertion.image
            dest.detailNumber = selectedInsertion.phoneNumber
            dest.detailEmail = selectedInsertion.email
        } else if segue.identifier == "lessonDetailSegue" {
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "it_IT")
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let dest = segue.destination as! TimelineDetailController
            let selectedLesson = self.chosenLesson
            let convertedObj = Lesson.init()
            convertedObj.course = selectedLesson?.course
            convertedObj.teacher = selectedLesson?.teacher
            convertedObj.lessonName = selectedLesson?.lessonName
            convertedObj.room = selectedLesson?.room
            convertedObj.lessonDate = dateFormatter.string(from: (selectedLesson?.lessonDate!)!)
            convertedObj.lessonStart = dateFormatter.string(from: (selectedLesson?.lessonStart!)!)
            convertedObj.lessonEnd = dateFormatter.string(from: (selectedLesson?.lessonEnd!)!)
            convertedObj.lessonType = selectedLesson?.lessonType
            convertedObj.lessonArea = selectedLesson?.lessonArea
            dest.selectedLesson = convertedObj
        }
    }
}
