//
//  HomeCollectionViewCell.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import SnapKit

class HomeCollectionViewCell: BaseCollectionViewCell {
    
    let cellBackground = UIView()
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let countLabel = UILabel()
    
    
    
    
    
    
    override func setHierarchy() {
        contentView.addSubview(cellBackground)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
    }
    
    override func setLayout() {
        
        cellBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(10)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconImageView.snp.centerX)
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.trailing.equalTo(contentView).offset(-15)
        }
    }
    
    override func setUI() {
        contentView.backgroundColor = .clear
        cellBackground.layer.cornerRadius = 10
        cellBackground.backgroundColor = .systemGray4
        
        iconImageView.image = UIImage(systemName: "calendar.circle.fill")
        
        
        titleLabel.text = "오늘"
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = .lightGray
        
        countLabel.text = "0"
        countLabel.font = .systemFont(ofSize: 30, weight: .bold)
        
    }
    
    
    
    
}

