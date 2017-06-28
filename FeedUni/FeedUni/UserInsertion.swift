//
//  UserInsertion.swift
//  FeedUni
//
//  Created by Reginato James on 28/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import Foundation
import RealmSwift

class UserInsertion: Object {
    //dynamic var userId = ""
    dynamic var title = ""
    dynamic var insertionDescription = ""
    dynamic var publisherName = ""
    dynamic var email = ""
    dynamic var phoneNumber = ""
    dynamic var price = 0   //Prezzo in centesimi
    dynamic var publishDate = 0.0
    dynamic var insertionType = 1
    dynamic var image = "" //In base in 64
}
