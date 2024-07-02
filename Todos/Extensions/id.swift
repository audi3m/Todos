//
//  id.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit

extension UITableViewCell {
    static var id: String {
        String(describing: self)
    }
}

extension UICollectionViewCell {
    static var id: String {
        String(describing: self)
    }
}
