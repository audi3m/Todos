//
//  DueDateViewController.swift
//  Todos
//
//  Created by J Oh on 7/3/24.
//

import UIKit
import SnapKit

class DueDateViewController: BaseViewController {
    
    let datePicker = UIDatePicker()
    
    var date: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "마감일"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        date?(datePicker.date) 
    }
    
    
    override func setHierarchy() {
        view.addSubview(datePicker)
    }
    
    override func setLayout() {
        datePicker.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setUI() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
    }
    
    
    
    
    
    
    
    
}
