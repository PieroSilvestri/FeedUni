//
//  RealmQueries.swift
//  FeedUni
//
//  Created by Reginato James on 21/06/17.
//  Copyright © 2017 Piero Silvestri. All rights reserved.
//

import Foundation
import RealmSwift

class RealmQueries {
    
    static let realm = try! Realm()
    
    //MARK: SELECT QUERIES
    //Ritorna tutte le news favorite
    static func getFavoritePosts() -> [FavoriteNews] {
        let news = Array(realm.objects(FavoriteNews.self))
        return news
    }
    
    //Ritorna tutti gli annunci favoriti
    static func getFavoriteInsertions() -> [FavoriteInsertion] {
        let insertions = Array(realm.objects(FavoriteInsertion.self))
        return insertions
    }
    
    //Ritorna tutte le lezioni favorite
    static func getFavoriteLessons() -> [FavoriteLesson] {
        let lessons = Array(realm.objects(FavoriteLesson.self))
        return lessons
    }
    
    
    //MARK: INSERT QUERIES
    //Inserimento di una news
    static func insertNews(post: FavoriteNews) {
        try! realm.write {
            realm.add(post)
        }
    }
    
    //Inserimento di inserzione della bacheca
    static func insertInsertion(insertion: FavoriteInsertion) {
        try! realm.write {
            realm.add(insertion)
        }
    }
    
    //Inserimento lezione
    static func insertLesson(lesson: FavoriteLesson) {
        try! realm.write {
            realm.add(lesson)
        }
    }
}
