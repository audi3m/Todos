//
//  ReminderTableViewCell.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import SnapKit

class ReminderTableViewCell: BaseTableViewCell {
    
    var data: TodoModel? {
        didSet {
            setData()
        }
    }
    
    let doneCircle = UIImageView()
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
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            
        }
        
        dueDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(doneCircle.snp.trailing).offset(15)
            make.top.equalTo(memoLabel.snp.bottom).offset(2)
            
        }
    }
    
    override func setUI() {
        contentView.backgroundColor = .clear
        
        doneCircle.image = UIImage(systemName: "circle")
        doneCircle.tintColor = .gray
        
        titleLabel.font = .systemFont(ofSize: 15)
        
        memoLabel.font = .systemFont(ofSize: 13)
        memoLabel.textColor = .gray
        
        dueDateLabel.font = .systemFont(ofSize: 13)
        dueDateLabel.textColor = .gray
        
    }
    
    private func setData() {
        guard let data else { return }
        
        let priorityMarks = String(repeating: "!", count: data.priority ?? 0)
        let fullText = "\(priorityMarks) \(data.title)"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let priorityRange = (fullText as NSString).range(of: priorityMarks)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: priorityRange)
        
        self.titleLabel.attributedText = attributedString
        self.memoLabel.text = data.memo
        self.dueDateLabel.text = data.dueDate?.formatted()
    }
    
}
