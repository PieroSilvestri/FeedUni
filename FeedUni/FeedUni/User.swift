//
//  User.swift
//  FeedUni
//
//  Created by Reginato James on 07/07/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var userName = ""
    dynamic var password = ""
    var insertions = List<UserInsertion>()
}
