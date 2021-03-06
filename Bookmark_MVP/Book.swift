//
//  Book.swift
//  BookIt
//
//  Created by Duc Le on 2/23/17.
//  Copyright © 2017 Team Grant_le_mandel. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class Book: Object {
    
    // Properties of a book
    dynamic var title: String         = ""
    dynamic var totalPages: Int       = 0
    dynamic var currentPage: Int      = 0
    dynamic var author: String        = ""
    dynamic var whenCreated: Date     = Date()
    dynamic var status: String        = "reading"
    dynamic var rating: Int           = 0
    dynamic var color: String         = ""
    
    
    // Failable initializer
    convenience init?(title: String, totalPages: Int, cover: UIImage? = #imageLiteral(resourceName: "default"), currentPage: Int = 0, author: String = "", status: String = "reading", whenCreated: Date = Date(), rating: Int = 0, color: String = "red") {
        if title.isEmpty || totalPages < 0 || currentPage < 0 {
            return nil
        }
        
        self.init()
        
        self.title         = title
        self.totalPages    = totalPages
        self.currentPage   = currentPage
        self.author        = author
        self.status        = status
        self.whenCreated   = whenCreated
        self.rating        = rating
        self.color         = color
    }
}
