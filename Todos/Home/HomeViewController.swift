//
//  ViewController.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import FSCalendar
import SnapKit

final class HomeViewController: BaseViewController {
    
//    let searchController = UISearchController(searchResultsController: ReminderListViewController(type: .withQuery, query: "ㅎ"))
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let addNewButton = UIButton()
    
    let repository = TodoRepository()
    fileprivate weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repository.printPath()
        
        setNavBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.id)
    }
    
    override func setHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(addNewButton)
    }
    
    override func setLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        addNewButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func setUI() {
        addNewButton.setTitle(" 새로운 할 일", for: .normal)
        addNewButton.setTitleColor(.systemBlue, for: .normal)
        addNewButton.titleLabel?.font = .systemFont(ofSize: 20)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: imageConfig)
        addNewButton.setImage(image, for: .normal)
        addNewButton.addTarget(self, action: #selector(addNewButtonClicked), for: .touchUpInside)
    }
    
    private func setNavBar() {
        navigationItem.title = "All"
//        navigationItem.searchController = searchController
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.placeholder = "검색"
        
        let calendar = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonClicked))
        navigationItem.leftBarButtonItem = calendar
    }
    
    @objc func addNewButtonClicked() {
        let vc = AddNewViewController()
        vc.sendAdded = { added in
            if added {
                self.collectionView.reloadData()
            }
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        nav.isModalInPresentation = true
        present(nav, animated: true)
    }
    
    @objc func calendarButtonClicked() {
        let calendar = FSCalendar(frame: CGRect(x: 30, y: 30, width: 320, height: 300))
        calendar.delegate = self
        calendar.dataSource = self
        view.addSubview(calendar)
        self.calendar = calendar
        self.calendar.backgroundColor = .white
    }
    
}

//extension HomeViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else { return }
//        
//    }
//    
//    
//}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        1
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let startDay = Calendar.current.startOfDay(for: date)
        let endDay: Date = Calendar.current.date(byAdding: .day, value: 1, to: startDay) ?? Date()
        let predicate = NSPredicate(format: "regDate >= %@ && regDate < %@",
                                    startDay as NSDate,
                                    endDay as NSDate)
        
        
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FilterType.allCases.prefix(5).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.id, for: indexPath) as! HomeCollectionViewCell
        let type = FilterType.allCases.prefix(5)[indexPath.item]
        cell.countLabel.text = "\(repository.filterCount(filter: type))"
        cell.setData(type: type)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = FilterType.allCases.prefix(5)[indexPath.item]
        let vc = ReminderListViewController(type: type, query: "")
        vc.sendUpdated = { updated in
            if updated {
                collectionView.reloadData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    static private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 15
        let width = UIScreen.main.bounds.width - (sectionSpacing * 2 + cellSpacing)
        layout.itemSize = CGSize(width: width/2, height: width/4)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
}

enum FilterType: String, CaseIterable {
    case today = "오늘"
    case scheduled = "예정"
    case all = "전체"
    case flagged = "깃발 표시"
    case completed = "완료됨"
    case withQuery = ""
    
    var circleColor: UIColor {
        switch self {
        case .today:
            return .systemBlue
        case .scheduled:
            return .systemRed
        case .all:
            return .systemGray
        case .flagged:
            return .systemOrange
        case .completed:
            return .lightGray
        case .withQuery:
            return .clear
        }
    }
    
    var icon: String {
        switch self {
        case .today:
            "clock.circle.fill"
        case .scheduled:
            "calendar.circle.fill"
        case .all:
            "tray.circle.fill"
        case .flagged:
            "flag.circle.fill"
        case .completed:
            "checkmark.circle.fill"
        case .withQuery:
            ""
        }
    }
}
