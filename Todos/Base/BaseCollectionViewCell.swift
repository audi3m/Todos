//
//  BaseCollectionViewCell.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        
        setHierarchy()
        setLayout()
        setUI()
    }
    
    func setHierarchy() { }
    func setLayout() { }
    func setUI() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
