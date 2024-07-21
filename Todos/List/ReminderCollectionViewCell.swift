//
//  ReminderCollectionViewCell.swift
//  Todos
//
//  Created by J Oh on 7/22/24.
//

import UIKit
import SnapKit

final class ReminderCollectionViewCell: BaseCollectionViewCell {
    
    var data: TodoModel? {
        didSet {
            setData()
        }
    }
    
    let doneButton = UIButton()
    let titleLabel = UILabel()
    let memoLabel = UILabel()
    let dueDateLabel = UILabel()
    let flag = UIImageView()
    let folderLabel = UILabel()
    
    override func setHierarchy() {
        contentView.addSubview(doneButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoLabel)
        contentView.addSubview(dueDateLabel)
        contentView.addSubview(flag)
        contentView.addSubview(folderLabel)
    }
    
    override func setLayout() {
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.leading.equalTo(contentView).inset(15)
            make.size.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(doneButton.snp.trailing).offset(15)
            make.centerY.equalTo(doneButton.snp.centerY)
            make.width.lessThanOrEqualTo(250)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.leading.equalTo(doneButton.snp.trailing).offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.width.lessThanOrEqualTo(250)
        }
        
        dueDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(doneButton.snp.trailing).offset(15)
            make.top.equalTo(memoLabel.snp.bottom).offset(2)
            make.width.lessThanOrEqualTo(250)
        }
        
        flag.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(doneButton.snp.centerY)
            make.size.equalTo(20)
        }
        
        folderLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(contentView).inset(20)
        }
    }
    
    override func setUI() {
        contentView.backgroundColor = .clear
        
        doneButton.tintColor = .gray
        
        titleLabel.font = .systemFont(ofSize: 15)
        
        memoLabel.font = .systemFont(ofSize: 14)
        memoLabel.textColor = .secondaryLabel
        
        dueDateLabel.font = .systemFont(ofSize: 13)
        dueDateLabel.textColor = .gray
        
        flag.tintColor = .systemOrange
        
        folderLabel.font = .systemFont(ofSize: 13)
        
    }
    
    private func setData() {
        guard let data else { return }
        
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let doneImage = UIImage(systemName: data.isDone ? "circle.inset.filled" : "circle", withConfiguration: config)
        doneButton.setImage(doneImage, for: .normal)
         
        let priorityMarks = String(repeating: "!", count: data.priority)
        let titleAttribute = customAttribute(colorSet: [.systemBlue, .label], frontText: priorityMarks, backText: data.title)
        
        let date = data.dueDate?.customFormat()
        let tag = data.hashTag
        let bottomAttribute = customAttribute(colorSet: [.secondaryLabel, .systemCyan], frontText: date, backText: tag)
        
        titleLabel.attributedText = titleAttribute
        memoLabel.text = data.memo
        dueDateLabel.attributedText = bottomAttribute
        flag.image = data.isFlagged ? UIImage(systemName: "flag.fill") : UIImage()
        folderLabel.text = data.folder.first?.name
        
    }
    
    private func customAttribute(colorSet: [UIColor], frontText: String?, backText: String?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        
        if let frontText, !frontText.isEmpty {
            let frontAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: colorSet[0]
            ]
            let attributedFrontText = NSAttributedString(string: frontText, attributes: frontAttributes)
            attributedString.append(attributedFrontText)
        }
        
        if let frontText, !frontText.isEmpty, let backText, !backText.isEmpty {
            attributedString.append(NSAttributedString(string: " "))
        }
        
        if let backText, !backText.isEmpty {
            let backAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: colorSet[1]
            ]
            let attributedBackText = NSAttributedString(string: backText, attributes: backAttributes)
            attributedString.append(attributedBackText)
        }
        
        return attributedString
    }
    
}
