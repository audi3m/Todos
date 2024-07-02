//
//  TodoModel.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import RealmSwift

class MoneyTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var title: String
    @Persisted var memo: String?
    @Persisted var dueDate: Date?
    
    convenience init(title: String, memo: String?, dueDate: Date?) {
        self.init()
        self.title = title
        self.memo = memo
        self.dueDate = dueDate
    }
    
} 