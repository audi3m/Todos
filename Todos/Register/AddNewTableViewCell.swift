//
//  AddNewTableViewCell.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import SnapKit

final class AddNewTableViewCell: BaseTableViewCell {
    
    let rectangleView = UIView()
    let attributeLabel = UILabel()
    let attributeValueLabel = UILabel()
    let arrowImageView = UIImageView()
    
    override func setHierarchy() {
        contentView.addSubview(rectangleView)
        rectangleView.addSubview(attributeValueLabel)
        rectangleView.addSubview(attributeLabel)
        rectangleView.addSubview(arrowImageView)
    }
    
    override func setLayout() {
        rectangleView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        
        attributeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(rectangleView.snp.leading).offset(15)
        }
        
        attributeValueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-20)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(rectangleView.snp.trailing).offset(-15)
        }
    }
    
    override func setUI() {
        contentView.backgroundColor = .clear
        
        rectangleView.layer.cornerRadius = 10
        rectangleView.backgroundColor = .systemGray4
        
        attributeLabel.font = .systemFont(ofSize: 15)
        
        attributeValueLabel.font = .systemFont(ofSize: 15)
        attributeValueLabel.text = "없음"
        attributeValueLabel.textColor = .secondaryLabel
        
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .white
    }
    
    func setAttributeValue(type: ValueType) {
        DispatchQueue.main.async {
            switch type {
            case .none:
                self.attributeValueLabel.text = "없음"
                self.attributeValueLabel.textColor = .secondaryLabel
            case .hasValue(let value):
                self.attributeValueLabel.text = value
                self.attributeValueLabel.textColor = .label
            }
        }
    }
    
    enum ValueType {
        case none
        case hasValue(value: String)
    }
    
}
