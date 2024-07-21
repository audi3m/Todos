//
//  ReminderListViewController.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class ReminderListViewController: BaseViewController {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    var dataSource: UICollectionViewDiffableDataSource<ListSections, TodoModel>!
    
    private lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.id)
        return view
    }()
    
    private var list: Results<TodoModel>!
    private var type: FilterType
    private let query: String
    let repository = TodoRepository()
    
    private var isUpdated = false
    var sendUpdated: ((Bool) -> Void)?
    
    init(type: FilterType, query: String) {
        self.type = type
        self.query = query
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        list = repository.filteredList(filter: type, query: query)
        
        configDataSource()
        updateSnapshot()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sendUpdated?(isUpdated)
    }
    
    private func setNavBar() {
        navigationItem.title = type.rawValue
        let addMenu = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "마감날짜순", image: UIImage(systemName: "calendar"), handler: { _ in
                self.sortByDueDate()
            }),
            UIAction(title: "제목순", image: UIImage(systemName: "quote.bubble"), handler: { _ in
                self.sortByTitle()
            }),
            UIAction(title: "우선순위", image: UIImage(systemName: "123.rectangle"), handler: { _ in
                self.sortByPriority()
            })
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: .menu, primaryAction: nil, menu: addMenu)
        
    }
    
    private func sortByDueDate() {
        list = list.sorted(byKeyPath: "dueDate", ascending: true)
        tableView.reloadData()
    }
    
    private func sortByTitle() {
        list = list.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    private func sortByPriority() {
        list = list.sorted(byKeyPath: "priority", ascending: false)
        tableView.reloadData()
    }
    
    override func setHierarchy() {
        view.addSubview(tableView)
//        view.addSubview(collectionView)
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
        
    }
    
}

// collectionView
extension ReminderListViewController {
    
    private func configDataSource() {
        var registration: UICollectionView.CellRegistration<ReminderCollectionViewCell, TodoModel>!
        registration = UICollectionView.CellRegistration { cell, indexPath, item in
            cell.data = item
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
            return cell
        })
    }
    
    // ---------------------------------------------------------------------------------------------------
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ListSections, TodoModel>()
        snapshot.appendSections(ListSections.allCases)
//        snapshot.appendItems(list, toSection: .all)
        dataSource.apply(snapshot) // reload
    }
    // ---------------------------------------------------------------------------------------------------
    
    private func layout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    enum ListSections: CaseIterable {
        case all
    }
    
}

extension ReminderListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.id, for: indexPath) as! ReminderTableViewCell
        let item = list[indexPath.row]
        cell.data = item
        cell.doneButton.tag = indexPath.row
        cell.doneButton.addTarget(self, action: #selector(doneClicked), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
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
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data = self.list[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, completionHandler in
            self.repository.deleteItem(data)
            self.isUpdated = true
            tableView.reloadData()
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let flagAction = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            self.repository.updateIsFlagged(data)
            self.isUpdated = true
            if self.type == .flagged {
                self.tableView.reloadData()
            } else {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        flagAction.backgroundColor = .systemOrange
        flagAction.image = UIImage(systemName: "flag.fill")
        
        let pinAction = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            
            
        }
        pinAction.image = UIImage(systemName: "pin.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, flagAction, pinAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    @objc private func doneClicked(sender: UIButton) {
        let data = list[sender.tag]
        repository.updateIsDone(data)
        isUpdated = true
        if type == .completed {
            tableView.reloadData()
        } else {
            tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        }
    }
    
}
