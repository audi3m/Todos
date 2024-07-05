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
    
    func fetchAll() -> Results<TodoModel> {
        let list = realm.objects(TodoModel.self).sorted(byKeyPath: "dueDate", ascending: false)
        print(realm.configuration.fileURL ?? "")
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
    
    func updateDone(_ data: TodoModel) {
        do {
            try realm.write {
                let isDone = data.isDone
                data.isDone = isDone ? false : true
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
    
    func filteredList(filter: FilterType) -> Results<TodoModel> {
        let originalList = realm.objects(TodoModel.self)
        switch filter {
        case .today:
            return originalList.filter(isToday())
        case .scheduled:
            return originalList.filter(isScheduled())
        case .all:
            return originalList
        case .flagged:
            return originalList.where { $0.isFlagged }
        case .completed:
            return originalList.where { $0.isDone }
        }
    }
    
    func isToday() -> NSPredicate {
        let today = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: today)
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
