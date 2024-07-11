//
//  CalendarListViewController.swift
//  Todos
//
//  Created by J Oh on 7/11/24.
//

import UIKit
import FSCalendar
import SnapKit

final class CalendarListViewController: BaseViewController {
    
    fileprivate weak var calendar: FSCalendar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = FSCalendar(frame: .zero)
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        self.calendar = calendar
        
    }
    
    
    override func setHierarchy() {
        
        
    }
    
    override func setLayout() {
//        calendar.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
//        }
    }
    
    override func setUI() {
        
        
    }
    
    
    
}


extension CalendarListViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        1
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let startDay = Calendar.current.startOfDay(for: date)
        let endDay: Date = Calendar.current.date(byAdding: .day, value: 1, to: startDay) ?? Date()
        let _ = NSPredicate(format: "regDate >= %@ && regDate < %@", startDay as NSDate, endDay as NSDate)
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        print(#function)
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
            // Do other updates
        }
        self.view.layoutIfNeeded()
    }
    
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        print(#function)
//        self.calendar.snp.makeConstraints { make in
//            make.height.equalTo(bounds.height)
//            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
//        }
//        self.view.layoutIfNeeded()
//    }
    
}
