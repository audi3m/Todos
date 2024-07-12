//
//  TodoRepository.swift
//  Todos
//
//  Created by J Oh on 7/4/24.
//

import Foundation
import RealmSwift

final class TodoRepository {
    
    // 싱글톤으로 이미 작동함
    private let realm = try! Realm()
    
    func printPath() {
        print(realm.configuration.fileURL ?? "")
    }
    
    func fetchAll() -> Results<TodoModel> {
        let list = realm.objects(TodoModel.self).sorted(byKeyPath: "dueDate", ascending: false)
        print(realm.configuration.fileURL ?? "")
        return list
    }
    
    func fetchByFolder(folder: Folder) -> Results<TodoModel> {
        let list = realm.objects(TodoModel.self).where { $0.folder == folder }
        return list
    }
    
    func createItem(_ data: TodoModel) {
        do {
            try realm.write {
                realm.add(data)
                print("Realm Create Success")
            }
        } catch {
            print(error)
        }
    }
    
    func updateItem(_ oldItem: TodoModel, with newItem: TodoModel) {
        guard let oldItemInRealm = realm.object(ofType: TodoModel.self, forPrimaryKey: oldItem.id) else { return }
        
        do {
            try realm.write {
                
                oldItemInRealm.title = newItem.title
                oldItemInRealm.memo = newItem.memo
                oldItemInRealm.dueDate = newItem.dueDate
                oldItemInRealm.tag = newItem.tag
                oldItemInRealm.priority = newItem.priority
                oldItemInRealm.isDone = newItem.isDone
                oldItemInRealm.isFlagged = newItem.isFlagged
                
                realm.add(oldItemInRealm, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func updateIsDone(_ data: TodoModel) {
        do {
            try realm.write {
                let isDone = data.isDone
                data.isDone = isDone ? false : true
            }
        } catch {
            print(error)
        }
    }
    
    func updateIsFlagged(_ data: TodoModel) {
        do {
            try realm.write {
                let isFlagged = data.isFlagged
                data.isFlagged = isFlagged ? false : true
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(_ data: TodoModel) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print(error)
        }
    }
    
    func schemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version:", version)
        } catch {
            print(error)
        }
    }
    
    func filterCount(filter: FilterType) -> Int {
        let originalList = realm.objects(TodoModel.self)
        switch filter {
        case .today:
            return originalList.filter(isInDate(Date())).count
        case .scheduled:
            return originalList.filter(isScheduled()).count
        case .all:
            return originalList.count
        case .flagged:
            return originalList.where { $0.isFlagged }.count
        case .completed:
            return originalList.where { $0.isDone }.count
        case .withQuery:
            return 0
        }
    }
    
    func filteredList(filter: FilterType, query: String) -> Results<TodoModel> {
        let originalList = realm.objects(TodoModel.self)
        switch filter {
        case .today:
            return originalList.filter(isInDate(Date()))
        case .scheduled:
            return originalList.filter(isScheduled())
        case .all:
            return originalList
        case .flagged:
            return originalList.where { $0.isFlagged }
        case .completed:
            return originalList.where { $0.isDone }
        case .withQuery:
            return originalList.filter(doesContain(query: query))
        }
    }
    
    func doesContain(query: String) -> NSPredicate {
        let predicate = NSPredicate(format: "title CONTAINS[c] %@ OR memo CONTAINS[c] %@", query, query)
        return predicate
    }
    
    func isInDate(_ date: Date) -> NSPredicate {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1)
        let predicate = NSPredicate(format: "dueDate >= %@ AND dueDate < %@", argumentArray: [startOfDay, endOfDay!])
        return predicate
    }
    
    func isScheduled() -> NSPredicate {
        let today = Date()
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: today)!)
        let predicate = NSPredicate(format: "dueDate >= %@", argumentArray: [tomorrow])
        return predicate
    }
    
}
