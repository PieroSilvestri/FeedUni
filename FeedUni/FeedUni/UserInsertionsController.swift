//
//  UserInsertionsController.swift
//  FeedUni
//
//  Created by Reginato James on 04/07/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import UIKit

class UserInsertionsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mTableView: UITableView!
    var userInsertions: [UserInsertion] = []

    let insertionFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertionFormatter.locale = Locale(identifier: "it_IT")
        insertionFormatter.timeZone = TimeZone(abbreviation: "UTC")
        insertionFormatter.dateFormat = "dd-MM-yyyy"
        
        navigationController?.navigationBar.tintColor = UIColor.white
        userInsertions = RealmQueries.getUserInsertions()
        self.mTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.userInsertions.count > 0 {
            let cell = self.mTableView.dequeueReusableCell(withIdentifier: "bachecaCellUser", for: indexPath) as! BachecaControllerTableViewCell
            let vInsertion = self.userInsertions[indexPath.row]
            cell.cellPrice.text = vInsertion.publisherName
            cell.cellTitle.text = vInsertion.title
            cell.cellData.text = insertionFormatter.string(from: vInsertion.publishDate!)
            
            var imageDecoded : UIImage? = nil
            let decodedData = Data(base64Encoded: vInsertion.image, options: .ignoreUnknownCharacters)
            if (decodedData != nil){
                let decodedimage = UIImage(data: decodedData!)
                if decodedimage != nil {
                    imageDecoded = decodedimage!
                }
            }

            if imageDecoded != nil {
                cell.cellImage.image = imageDecoded
            }
            
            cell.onButtonTapped = {
                RealmQueries.deleteUserInsertion(userInsertion: self.userInsertions[indexPath.row])
                self.userInsertions.remove(at: indexPath.row)
                self.mTableView.reloadData()
            }
            
            return cell
        } else {
            self.mTableView.estimatedRowHeight = 300
            self.mTableView.rowHeight = UITableViewAutomaticDimension
            return self.mTableView.dequeueReusableCell(withIdentifier: "noInsertionCell")!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userInsertions.count > 0 {
            return userInsertions.count
        } else {
            return 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! BachecaDetailController
        let index = self.mTableView.indexPath(for: sender as! BachecaControllerTableViewCell)?.row
        let selectedInsertion = self.userInsertions[index!]
        dest.detailTitle = selectedInsertion.title
        dest.detailDescription = selectedInsertion.description
        dest.detailPrice = "\(selectedInsertion.price/100)"
        dest.detailUser = selectedInsertion.publisherName
        dest.detailData = "\(selectedInsertion.publishDate)"
        dest.detailImage = selectedInsertion.image
        dest.detailNumber = selectedInsertion.phoneNumber
        dest.detailEmail = selectedInsertion.email
    }

}
