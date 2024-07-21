//
//  PriorityViewController.swift
//  Todos
//
//  Created by J Oh on 7/3/24.
//

import UIKit
import SnapKit

final class PriorityViewController: BaseViewController {
    
    let viewModel = PriorityViewModel(.none)
    
    private let segmentPicker = UISegmentedControl()
    let priorityLabel = UILabel()
    
    var sendPriority: ((Priority) -> Void)?
    var selectedPriority: Priority = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "우선 순위"
        segmentPicker.selectedSegmentIndex = selectedPriority.rawValue
        viewModel.inputPriority.value = selectedPriority
        bindData()
    }
    
    func bindData() {
        viewModel.outputPriorityText.bind { value in
            self.priorityLabel.text = value
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendPriority?(selectedPriority)
    }
    
    override func setHierarchy() {
        view.addSubview(segmentPicker)
        view.addSubview(priorityLabel)
    }
    
    override func setLayout() {
        segmentPicker.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentPicker.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func setUI() {
        segmentPicker.insertSegment(withTitle: "없음", at: 0, animated: false)
        segmentPicker.insertSegment(withTitle: "낮음", at: 1, animated: false)
        segmentPicker.insertSegment(withTitle: "보통", at: 2, animated: false)
        segmentPicker.insertSegment(withTitle: "높음", at: 3, animated: false)
        segmentPicker.addTarget(self, action: #selector(priorityChanged(_:)), for: .valueChanged)
        
        priorityLabel.textAlignment = .center
    }
    
    @objc func priorityChanged(_ sender: UISegmentedControl) {
        guard let priority = Priority(rawValue: sender.selectedSegmentIndex) else { return }
        selectedPriority = priority
        viewModel.inputPriority.value = priority
    }
}

enum Priority: Int {
    case none
    case low
    case medium
    case high
    
    var stringValue: String {
        switch self {
        case .none:
            return "없음"
        case .low:
            return "낮음"
        case .medium:
            return "보통"
        case .high:
            return "높음"
        }
    }
    
}
