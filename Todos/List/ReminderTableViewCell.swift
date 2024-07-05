//
//  ReminderTableViewCell.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import SnapKit

final class ReminderTableViewCell: BaseTableViewCell {
    
    var data: TodoModel? {
        didSet {
            setData()
        }
    }
    
    let doneCircle = UIButton()
    let titleLabel = UILabel()
    let memoLabel = UILabel()
    let dueDateLabel = UILabel()
    
    override func setHierarchy() {
        contentView.addSubview(doneCircle)
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoLabel)
        contentView.addSubview(dueDateLabel)
    }
    
    override func setLayout() {
        doneCircle.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.leading.equalTo(contentView).inset(15)
            make.size.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(doneCircle.snp.trailing).offset(15)
            make.centerY.equalTo(doneCircle.snp.centerY)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.leading.equalTo(doneCircle.snp.trailing).offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        dueDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(doneCircle.snp.trailing).offset(15)
            make.top.equalTo(memoLabel.snp.bottom).offset(2)
        }
    }
    
    override func setUI() {
        contentView.backgroundColor = .clear
        
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: data?.isDone ?? false ? "circle.inset.filled" : "circle", withConfiguration: config)
        doneCircle.setImage(image, for: .normal)
        
        doneCircle.tintColor = .gray
        
        titleLabel.font = .systemFont(ofSize: 15)
        
        memoLabel.font = .systemFont(ofSize: 14)
        memoLabel.textColor = .gray
        
        dueDateLabel.font = .systemFont(ofSize: 13)
        dueDateLabel.textColor = .gray
        
    }
    
    private func setData() {
        guard let data else { return }
         
        let priorityMarks = String(repeating: "!", count: data.priority ?? 0)
        let titleAttribute = customAttribute(colorSet: [.systemBlue, .label], frontText: priorityMarks, backText: data.title)
        
        let date = data.dueDate?.customFormat()
        let tag = data.hashTag
        let bottomAttribute = customAttribute(colorSet: [.label, .systemCyan], frontText: date, backText: tag)
        
        self.titleLabel.attributedText = titleAttribute
        self.memoLabel.text = data.memo
        self.dueDateLabel.attributedText = bottomAttribute
        
    }
    
    func customAttribute(colorSet: [UIColor], frontText: String?, backText: String?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        
        // Append frontText if it is not nil and not empty
        if let frontText, !frontText.isEmpty {
            let frontAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: colorSet[0]
            ]
            let attributedFrontText = NSAttributedString(string: frontText, attributes: frontAttributes)
            attributedString.append(attributedFrontText)
        }
        
        // Append space if both frontText and backText are not nil and not empty
        if let frontText, !frontText.isEmpty, let backText, !backText.isEmpty {
            attributedString.append(NSAttributedString(string: " "))
        }
        
        // Append backText if it is not nil and not empty
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
