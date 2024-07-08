//
//  AddNewFolderViewController.swift
//  Todos
//
//  Created by J Oh on 7/8/24.
//

import UIKit
import SnapKit

final class AddNewFolderViewController: BaseViewController {
    
    let repository = FolderRepository()
    
    private let rectangleView = UIView()
    private let nameTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        
    }
    
    private func setNavBar() {
        navigationItem.title = "새로운 폴더"
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        let add = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = add
    }
    
    override func setHierarchy() {
        view.addSubview(rectangleView)
        rectangleView.addSubview(nameTextField)
    }
    
    override func setLayout() {
        rectangleView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        
    }
    
    override func setUI() {
        rectangleView.layer.cornerRadius = 10
        rectangleView.backgroundColor = .systemGray4
        
        nameTextField.placeholder = "폴더 이름을 입력하세요"
        nameTextField.delegate = self
        
    }
    
    @objc private func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc private func addButtonClicked() {
        let name = nameTextField.text!
        let newFolder = Folder()
        newFolder.name = name
        repository.createItem(newFolder)
        dismiss(animated: true)
    }
    
    
}

extension AddNewFolderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
