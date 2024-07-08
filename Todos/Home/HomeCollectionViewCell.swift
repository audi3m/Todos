//
//  HomeCollectionViewCell.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import SnapKit

final class HomeCollectionViewCell: BaseCollectionViewCell {
    
    private let cellBackground = UIView()
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
            make.size.equalTo(37)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.leading.equalTo(iconImageView.snp.leading)
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
        
        titleLabel.text = "오늘"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label.withAlphaComponent(0.7)
        
        countLabel.text = "0"
        countLabel.font = .boldSystemFont(ofSize: 30)
        
    }
    
    func setData(type: FilterType) {
        titleLabel.text = type.rawValue
        let config = UIImage.SymbolConfiguration(paletteColors: [.white, type.circleColor])
        iconImageView.image = UIImage(systemName: type.icon)
        iconImageView.preferredSymbolConfiguration = config
    }
    
}

