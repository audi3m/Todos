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
    
    lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderTableViewCell.id)
        return view
    }()
    
    var list: Results<TodoModel>!
    var type: FilterType
    let query: String
    let repository = TodoRepository()
    
    var isUpdated = false
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
    
//    @objc private func addButtonClicked() {
//        let vc = AddNewViewController()
//        let nav = UINavigationController(rootViewController: vc)
//        present(nav, animated: true)
//    }
    
    override func setHierarchy() {
        view.addSubview(tableView)
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
    
    @objc func doneClicked(sender: UIButton) {
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
