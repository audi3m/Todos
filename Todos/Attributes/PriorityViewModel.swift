//
//  PriorityViewModel.swift
//  Todos
//
//  Created by J Oh on 7/9/24.
//

import Foundation

final class PriorityViewModel {
    
    var inputPriority: Observable<Priority?> = Observable(nil)
    var outputPriorityText: Observable<String?> = Observable(nil)
    
    init(_ priority: Priority) {
        print("ViewModel init")
        inputPriority.value = priority
        inputPriority.bind { _ in
            self.validation()
        }
    }
    
    private func validation() {
        guard let priority = inputPriority.value else { return }
        outputPriorityText.value = priority.stringValue
    }
    
}
