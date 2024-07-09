//
//  DueDateViewModel.swift
//  Todos
//
//  Created by J Oh on 7/9/24.
//

import Foundation

final class DueDateViewModel {
    
    var inputDate: Observable<Date?> = Observable(nil)
    var outputDateText: Observable<String?> = Observable(nil)
    var date: Date?
    
    init() {
        print("ViewModel init")
        if let date {
            inputDate.value = date
        }
        inputDate.bind { _ in
            self.validation()
        }
    }
    
    private func validation() {
        guard let date = inputDate.value else { return }
        outputDateText.value = date.customFormat()
    }
    
}
