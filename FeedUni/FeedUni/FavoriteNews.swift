//
//  FavoriteNews.swift
//  FeedUni
//
//  Created by Reginato James on 21/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import Foundation
import RealmSwift

//Tabella che contiene i post riguardanti le news
class FavoriteNews: Object {
    dynamic var id = "" //Mettere quello tornato dal backend di zeze
    dynamic var title = ""
    dynamic var content = ""
    dynamic var excerpt = ""
    dynamic var publishingDate: Date!
    dynamic var imageURL = ""
}
