//
//  TagViewController.swift
//  Todos
//
//  Created by J Oh on 7/3/24.
//

import UIKit
import SnapKit

class TagViewController: BaseViewController {
    
    let tagTextField = UITextField()
    var sendTag: ((String) -> Void)?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "테그"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendTag?(tagTextField.text ?? "")
    }
    
    override func setHierarchy() {
        view.addSubview(tagTextField)
    }
    
    override func setLayout() {
        tagTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func setUI() {
        tagTextField.placeholder = "테그"
        tagTextField.backgroundColor = .systemGray6
    } 
    
}
