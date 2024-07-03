//
//  Date+Ex.swift
//  Todos
//
//  Created by J Oh on 7/4/24.
//

import Foundation

extension Date {
    func customFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. (E)"
        return dateFormatter.string(from: self)
    }
}
