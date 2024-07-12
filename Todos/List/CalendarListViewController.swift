//
//  CalendarListViewController.swift
//  Todos
//
//  Created by J Oh on 7/11/24.
//

import UIKit
import FSCalendar
import RealmSwift
import SnapKit

final class CalendarListViewController: BaseViewController {
    
    let viewModel = CalendarViewModel()
    let tableView = UITableView()
    private lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scope = .week
        calendar.calendarHeaderView.isHidden = true
        calendar.headerHeight = 0
        calendar.scrollEnabled = true
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.placeholderType = .none
        calendar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
        return calendar
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "yyyy년 M월"
        return df
    }()
    
    var calendarScope = false
    var dueDateList = [Date]()
    var list: Results<TodoModel>!
    
    private var isUpdated = false
    var sendUpdated: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        list = viewModel.outputList.value
        dueDateList = viewModel.dueDateList
        
        bindData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sendUpdated?(isUpdated)
    }
    
    private func bindData() {
        viewModel.outputScope.bind { value in
            self.navigationItem.rightBarButtonItem?.title = value ? "주 달력" : "월 달력"
            self.calendarView.setScope(value ? .month : .week, animated: true)
        }
        
        viewModel.outputList.bind { value in
            self.list = value
            self.tableView.reloadData()
        }
    }
    
    private func setNavigationBar() {
        navigationItem.title = self.dateFormatter.string(from: Date())
        navigationItem.largeTitleDisplayMode = .never
        
        let scope = UIBarButtonItem(title: "주 달력", style: .plain, target: self, action: #selector(scopeClicked))
        navigationItem.rightBarButtonItem = scope
        
    }
    
    @objc private func scopeClicked() {
        calendarScope.toggle()
        viewModel.inputScope.value = calendarScope
    }
    
    override func setHierarchy() {
        view.addSubview(calendarView)
        view.addSubview(tableView)
    }
    
    override func setLayout() {
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setUI() {
        calendarView.backgroundColor = .systemGray6
        calendarView.layer.cornerRadius = 10
    }
}

extension CalendarListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: .none)
        let item = list[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.memo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = list[indexPath.row]
        let vc = DetailViewController(item: item)
        vc.updated = { isUpdated in
            if isUpdated {
                self.isUpdated = true
                tableView.reloadData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension CalendarListViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        containsDate(eventsList: dueDateList, date: date) ? 1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.inputDate.value = date
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        navigationItem.title = self.dateFormatter.string(from: calendar.currentPage)
    }
    
    func containsDate(eventsList: [Date], date: Date) -> Bool {
        for event in eventsList {
            if event.isSameDay(as: date) {
                return true
            }
        }
        return false
    }
    
}
