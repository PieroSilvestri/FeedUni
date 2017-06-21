//
//  FavoriteInsertion.swift
//  FeedUni
//
//  Created by Reginato James on 21/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteInsertion: Object {
    dynamic var title = ""
    dynamic var insertionDescription = ""
    dynamic var publisherName = ""
    dynamic var email = ""
    dynamic var phoneNumber = ""
    dynamic var price = 0.0
    dynamic var publishDate: Date?
    let insertionType = LinkingObjects(fromType: InsertionType.self, property: "booksType")
}
