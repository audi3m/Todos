//
//  PriorityViewController.swift
//  Todos
//
//  Created by J Oh on 7/3/24.
//

import UIKit
import SnapKit

class PriorityViewController: BaseViewController {
    
    let segmentPicker = UISegmentedControl()
    var priority: ((String) -> Void)?
    var selectedPriority: Priority = .low
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "우선 순위"
        segmentPicker.selectedSegmentIndex = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        priority?(selectedPriority.stringValue)
    }
    
    override func setHierarchy() {
        view.addSubview(segmentPicker)
    }
    
    override func setLayout() {
        segmentPicker.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func setUI() { 
        segmentPicker.insertSegment(withTitle: "낮음", at: 0, animated: false)
        segmentPicker.insertSegment(withTitle: "보통", at: 1, animated: false)
        segmentPicker.insertSegment(withTitle: "높음", at: 2, animated: false)
        segmentPicker.addTarget(self, action: #selector(priorityChanged(_:)), for: .valueChanged)
    }
    
    @objc func priorityChanged(_ sender: UISegmentedControl) {
        guard let priority = Priority(rawValue: sender.selectedSegmentIndex) else { return }
        selectedPriority = priority
    }
}

enum Priority: Int {
    case low
    case medium
    case high
    
    var stringValue: String {
        switch self {
        case .low:
            return "낮음"
        case .medium:
            return "보통"
        case .high:
            return "높음"
        }
    }
}