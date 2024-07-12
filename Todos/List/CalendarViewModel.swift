//
//  CalendarViewModel.swift
//  Todos
//
//  Created by J Oh on 7/12/24.
//

import Foundation
import RealmSwift

final class CalendarViewModel {
    
    let repository = TodoRepository()
    var dueDateList: [Date] = []
    
    var inputScope: Observable<Bool> = Observable(false)
    var outputScope: Observable<Bool> = Observable(false)
    
    var inputDate: Observable<Date> = Observable(Date())
    var outputList: Observable<Results<TodoModel>?> = Observable(nil)
    
    init() {
        filterDueDate()
        
        inputDate.bind { date in
            self.filterForDate(date)
        }
        
        inputScope.bind { scope in
            self.outputScope.value = scope
        }
    }
    
    private func filterForDate(_ date: Date) {
        let predicate = repository.isInDate(date)
        let list = repository.fetchAll().filter(predicate)
        outputList.value = list
    }
    
    private func filterDueDate() {
        let list = repository.fetchAll()
        for item in list {
            if let date = item.dueDate {
                dueDateList.append(date)
            }
        }
        
    }
    
    
    
    
}
