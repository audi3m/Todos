//
//  DueDateViewController.swift
//  Todos
//
//  Created by J Oh on 7/3/24.
//

import UIKit
import SnapKit

final class DueDateViewController: BaseViewController {
    
    let viewModel = DueDateViewModel(.now)
    
    let datePicker = UIDatePicker()
    let selectedDateLabel = UILabel()
    private let noDueDateButton = UIButton()
    
    var selectedDate: Date?
    var sendDate: ((Date?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "마감일"
        selectedDate = datePicker.date
        viewModel.inputDate.value = selectedDate
        bindData()
    }
    
    func bindData() {
        viewModel.outputDateText.bind { value in
            self.selectedDateLabel.text = value
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendDate?(selectedDate)
    }
    
    override func setHierarchy() {
        view.addSubview(datePicker)
        view.addSubview(selectedDateLabel)
        view.addSubview(noDueDateButton)
    }
    
    override func setLayout() {
        datePicker.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        selectedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        noDueDateButton.snp.makeConstraints { make in
            make.top.equalTo(selectedDateLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
    }
    
    override func setUI() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        self.datePicker.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
        
        noDueDateButton.setTitle("마감일 삭제", for: .normal)
        noDueDateButton.backgroundColor = .systemRed
        noDueDateButton.layer.cornerRadius = 10
        noDueDateButton.addTarget(self, action: #selector(deleteDueDate), for: .touchUpInside)
    }
    
    @objc private func onDateValueChanged(_ datePicker: UIDatePicker) {
        print(#function)
        selectedDate = datePicker.date
        viewModel.inputDate.value = selectedDate
    }
    
    @objc private func deleteDueDate() {
        selectedDate = nil
        navigationController?.popViewController(animated: true)
    }
    
}
