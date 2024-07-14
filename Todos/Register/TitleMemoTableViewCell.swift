//
//  TitleMemoTableViewCell.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import SnapKit

final class TitleMemoTableViewCell: BaseTableViewCell {
    
    private  let rectangleView = UIView()
    let titleTextField = UITextField()
    private let divider = UIView()
    let memoTextField = UITextField()
    
    override func setHierarchy() {
        contentView.addSubview(rectangleView)
        rectangleView.addSubview(titleTextField)
        rectangleView.addSubview(divider)
        rectangleView.addSubview(memoTextField)
    }
    
    override func setLayout() {
        rectangleView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(160)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(rectangleView).inset(15)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(15)
            make.leading.equalTo(rectangleView.snp.leading).offset(20)
            make.trailing.equalTo(rectangleView.snp.trailing)
            make.height.equalTo(1)
        }
        
        memoTextField.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(rectangleView).inset(15)
        }
    }
    
    override func setUI() {
        contentView.backgroundColor = .clear
        
        rectangleView.layer.cornerRadius = 10
        rectangleView.backgroundColor = .systemGray6
        
        titleTextField.placeholder = "제목"
        titleTextField.font = .systemFont(ofSize: 15)
        titleTextField.delegate = self
        
        memoTextField.placeholder = "메모"
        memoTextField.font = .systemFont(ofSize: 15)
        memoTextField.delegate = self
        
        divider.backgroundColor = .placeholderText
    }
    
}

extension TitleMemoTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
    
}
