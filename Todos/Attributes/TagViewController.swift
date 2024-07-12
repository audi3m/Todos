//
//  TagViewController.swift
//  Todos
//
//  Created by J Oh on 7/3/24.
//

import UIKit
import SnapKit

final class TagViewController: BaseViewController {
    
    let tagTextField = UITextField()
    private  let underBar = UIView()
    private let deleteTagButton = UIButton()
    
    var sendTag: ((String?) -> Void)?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "태그"
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let text = tagTextField.text!
        if text.isEmptyOrWhiteSpace() {
            sendTag?(nil)
        } else {
            sendTag?(tagTextField.text ?? "")
        }
    }
    
    override func setHierarchy() {
        view.addSubview(tagTextField)
        view.addSubview(underBar)
        view.addSubview(deleteTagButton)
    }
    
    override func setLayout() {
        tagTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.height.equalTo(50)
        }
        
        underBar.snp.makeConstraints { make in
            make.top.equalTo(tagTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
        }
        
        deleteTagButton.snp.makeConstraints { make in
            make.top.equalTo(tagTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
    }
    
    override func setUI() {
        tagTextField.placeholder = "#태그"
        tagTextField.delegate = self
        
        underBar.backgroundColor = .placeholderText
        
        deleteTagButton.setTitle("태그 삭제", for: .normal)
        deleteTagButton.backgroundColor = .systemRed
        deleteTagButton.layer.cornerRadius = 10
        deleteTagButton.addTarget(self, action: #selector(deleteTag), for: .touchUpInside)
    }
    
    @objc private func deleteTag() {
        tagTextField.text = ""
        navigationController?.popViewController(animated: true)
    }
}

extension TagViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
