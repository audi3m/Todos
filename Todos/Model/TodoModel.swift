//
//  TodoModel.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import RealmSwift

class TodoModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var title: String
    @Persisted var memo: String?
    @Persisted var dueDate: Date?
    @Persisted var tag: String?
    @Persisted var priority: Int?
    
    convenience init(title: String, memo: String?, dueDate: Date?, tag: String?, priority: Int?) {
        self.init()
        self.title = title
        self.memo = memo
        self.dueDate = dueDate
        self.tag = tag
        self.priority = priority
    }
    
} 
