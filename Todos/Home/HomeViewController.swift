//
//  ViewController.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
    
//    let searchController = UISearchController(searchResultsController: ReminderListViewController(type: .withQuery, query: "ㅎ"))
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    private let addNewToDoButton = UIButton()
    private let addNewFolderButton = UIButton()
    
    let toDoRepository = TodoRepository()
    let folderRepository = FolderRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoRepository.printPath()
        
        setNavBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.id)
    }
    
    override func setHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(addNewToDoButton)
        view.addSubview(addNewFolderButton)
    }
    
    override func setLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        addNewToDoButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        addNewFolderButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func setUI() {
        addNewToDoButton.setTitle(" 새로운 할 일", for: .normal)
        addNewToDoButton.setTitleColor(.systemBlue, for: .normal)
        addNewToDoButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        
        let toDoButtonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: toDoButtonConfig)
        addNewToDoButton.setImage(image, for: .normal)
        addNewToDoButton.addTarget(self, action: #selector(addNewButtonClicked), for: .touchUpInside)
        
        addNewFolderButton.setTitle("목록 추가", for: .normal)
        addNewFolderButton.setTitleColor(.systemBlue, for: .normal)
        addNewFolderButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        addNewFolderButton.addTarget(self, action: #selector(addNewFolderClicked), for: .touchUpInside)
    }
    
    private func setNavBar() {
        navigationItem.title = "할 일"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //        navigationItem.searchController = searchController
        //        searchController.searchResultsUpdater = self
        //        searchController.searchBar.placeholder = "검색"
        let folderMenu = createFolderMenu()
        
        let calendar = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonClicked))
        let folder = UIBarButtonItem(title: nil, image: UIImage(systemName: "folder"), primaryAction: nil, menu: folderMenu)
        navigationItem.leftBarButtonItem = calendar
        navigationItem.rightBarButtonItem = folder
    }
    
    func createFolderMenu() -> UIMenu {
        let folders = folderRepository.fetchFolders()
        var actions = [UIAction]()
        
        for folder in folders {
            let action = UIAction(title: folder.name, image: nil, handler: { [weak self] _ in
                let vc = FolderViewController()
                vc.folder = folder
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            actions.append(action)
        }
        
        return UIMenu(title: "", options: .displayInline, children: actions)
    }
    
    @objc private func addNewFolderClicked() {
        let vc = AddNewFolderViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
//        nav.isModalInPresentation = true
        present(nav, animated: true)
    }
    
    @objc private func addNewButtonClicked() {
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
    
    @objc private func folderButtonClicked() {
        
    }
    
    @objc private func calendarButtonClicked() {
        let vc = CalendarListViewController()
        vc.sendUpdated = { isUpdated in
            if isUpdated {
                self.collectionView.reloadData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
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


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FilterType.allCases.prefix(5).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.id, for: indexPath) as! HomeCollectionViewCell
        let type = FilterType.allCases.prefix(5)[indexPath.item]
        cell.countLabel.text = "\(toDoRepository.filterCount(filter: type))"
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
