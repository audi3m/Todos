//
//  FolderRepository.swift
//  Todos
//
//  Created by J Oh on 7/8/24.
//

import Foundation
import RealmSwift

final class FolderRepository {
    
    private let realm = try! Realm()
    
    func createItem(_ data: Folder) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print(error)
        }
    }
    
    func fetchFolders() -> Results<Folder> {
        let list = realm.objects(Folder.self)
        return list
    }
    
    func addItem(_ folder: Folder, newTodo: TodoModel) {
        do {
            try realm.write {
                folder.toDoList.append(newTodo)
            }
        } catch {
            print(error)
        }
    }
    
    func updateFolder(_ data: Folder, newName: String) {
        do {
            try realm.write {
                data.name = newName
            }
        } catch {
            print(error)
        }
    }
    
    func deleteFolder(_ folder: Folder) {
        do {
            try realm.write {
                realm.delete(folder.toDoList)
                realm.delete(folder)
            }
        } catch {
            print(error)
        }
    }
    
    func printRealmURL() {
        print(realm.configuration.fileURL ?? "")
    }
}
