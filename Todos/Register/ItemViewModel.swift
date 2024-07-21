//
//  ItemViewModel.swift
//  Todos
//
//  Created by J Oh on 7/12/24.
//

import Foundation

final class ItemViewModel {
    
    var inputItem: Observable<TodoModel?> = Observable(nil)
    
    var inputTitle: Observable<String> = Observable("")
    var inputMemo: Observable<String> = Observable("")
    var inputDueDate: Observable<Date?> = Observable(nil)
    var inputIsFlagged: Observable<Bool> = Observable(false)
    var inputIsDone: Observable<Bool> = Observable(false)
    var inputTag: Observable<String?> = Observable(nil)
    var inputPriority: Observable<Int> = Observable(0)
    
    var inputFolder: Observable<Folder?> = Observable(nil)
    
    var outputItem: Observable<TodoModel?> = Observable(nil)
    
    init() {
        if let item = inputItem.value {
            
        }
        
        update()
    }
    
    private func update() {
        inputTitle.bind { value in
            self.outputItem.value?.title = value
        }
        
        inputMemo.bind { value in
            self.outputItem.value?.memo = value
        }
        
        inputDueDate.bind { value in
            self.outputItem.value?.dueDate = value
        }
        
        inputIsFlagged.bind { value in
            self.outputItem.value?.isFlagged = value
        }
        
        inputIsDone.bind { value in
            self.outputItem.value?.isDone = value
        }
        
        inputTag.bind { value in
            self.outputItem.value?.tag = value
        }
        
        inputPriority.bind { value in
            self.outputItem.value?.priority = value
        }
        
//        inputFolder.bind { value in
//            self.outputItem.value?.folder = value
//        }
    }
    
}
