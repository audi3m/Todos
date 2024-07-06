//
//  String+Ex.swift
//  Todos
//
//  Created by J Oh on 7/6/24.
//

import UIKit

extension String {
    func isEmptyOrWhiteSpace() -> Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
