//
//  PriorityViewModel.swift
//  Todos
//
//  Created by J Oh on 7/9/24.
//

import Foundation

final class PriorityViewModel {
    
    var inputPriority: Observable<Priority> = Observable(.none)
    var outputPriorityText: Observable<String?> = Observable(nil)
    
    init(_ priority: Priority) {
        print("ViewModel init")
        inputPriority.value = priority
        inputPriority.bind { _ in
            self.validation()
        }
    }
    
    private func validation() {
        let priority = inputPriority.value
        outputPriorityText.value = priority.stringValue
    }
    
}
