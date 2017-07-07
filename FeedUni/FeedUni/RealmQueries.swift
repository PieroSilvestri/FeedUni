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
    
    //Ritorna tutte le inserzioni inserite dall'utente
    static func getUserInsertions() -> [UserInsertion] {
        let userInsertions = Array(realm.objects(UserInsertion.self))
        return userInsertions
    }
    
    
    //MARK: INSERT QUERIES
    //Inserimento di una news
    static func insertNews (post: FavoriteNews) {
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
    
    //Inserimento inserzioni postate dall'utente
    static func insertUserInsertion(userInsertion: UserInsertion) {
        try! realm.write {
            realm.add(userInsertion)
        }
    }
    
    
    //MARK: DELETE QUERIES
    //Eliminazione di una news
    static func deleteNews(post: FavoriteNews) {
        try! realm.write {
            realm.delete(post)
        }
    }
    
    //Eliminazione di inserzione della bacheca
    static func deleteInsertion(insertion: FavoriteInsertion) {
        try! realm.write {
            realm.delete(insertion)
        }
    }
    
    //Eliminazione lezione
    static func deleteLesson(lesson: FavoriteLesson) {
        try! realm.write {
            realm.delete(lesson)
        }
    }
    
    //Eliminazione inserzione dell'utente
    static func deleteUserInsertion(userInsertion: UserInsertion) {
        try! realm.write {
            realm.delete(userInsertion)
        }
    }
    
    
    //MARK: EDIT QUERIES
    //Modifica inserzione in bacheca (da decidere se utile)
    static func editInsertion(newInsertion: FavoriteInsertion) {
        try! realm.write {
            realm.create(FavoriteInsertion.self, value: ["title" : newInsertion.title, "insertionDescription" : newInsertion.description, "publisherName" : newInsertion.publisherName, "email" : newInsertion.email, "phoneNumber" : newInsertion.phoneNumber, "price" : newInsertion.price, "publishDate" : newInsertion.publishDate!, "insertionType" : newInsertion.insertionType], update: true)
        }
    }
}
