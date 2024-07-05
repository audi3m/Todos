//
//  ViewController.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let addNewButton = UIButton()
    
    let repository = TodoRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        addNewButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: imageConfig)
        addNewButton.setImage(image, for: .normal)
        addNewButton.addTarget(self, action: #selector(addNewButtonClicked), for: .touchUpInside)
        
    }
    
    private func setNavBar() {
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        let menu = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(menuButtonClicked))
        navigationItem.rightBarButtonItem = menu
    }
    
    @objc func addNewButtonClicked() {
        let vc = AddNewViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
    
    @objc func menuButtonClicked() {
        
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FilterType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.id, for: indexPath) as! HomeCollectionViewCell
        let type = FilterType.allCases[indexPath.item]
        cell.countLabel.text = "\(repository.filterCount(filter: type))"
        cell.setData(type: type)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = FilterType.allCases[indexPath.item]
        let vc = ReminderListViewController(type: type)
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
        }
    }
}
