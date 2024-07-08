//
//  TodoModel.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import RealmSwift

final class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var toDoList: List<TodoModel>
}

final class TodoModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var title: String
    @Persisted var memo: String
    @Persisted var dueDate: Date?
    @Persisted var isFlagged = false
    @Persisted var isDone = false
    @Persisted var tag: String?
    @Persisted var priority: Int = 0
    
    @Persisted(originProperty: "toDoList") var folder: LinkingObjects<Folder>
    
    convenience init(title: String, memo: String, dueDate: Date?, tag: String?, priority: Int) {
        self.init()
        self.title = title
        self.memo = memo
        self.dueDate = dueDate
        self.tag = tag
        self.priority = priority
    }
    
    var hashTag: String? {
        if let tag {
            return "#" + tag
        } else {
            return nil
        }
    }
    
} 
