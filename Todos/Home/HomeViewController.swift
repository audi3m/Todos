//
//  ViewController.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class HomeViewController: BaseViewController {
    
    let tableView = UITableView()
    
    var list: Results<TodoModel>!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list = realm.objects(TodoModel.self)
        
        setNavBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeCollectionViewCell.self, forCellReuseIdentifier: HomeCollectionViewCell.id)
        
    }
    
    private func setNavBar() {
        navigationItem.title = "목록"
        let add = UIBarButtonItem(image: .plus, style: .plain, target: self, action: #selector(addButtonClicked))
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
        navigationItem.leftBarButtonItem = add
        
    }
    
    @objc private func menuButtonClicked() {
        
    }
    
    private func sortByDueDate() {
        list = realm.objects(TodoModel.self)
            .sorted(byKeyPath: "dueDate", ascending: true)
    }
    
    private func sortByTitle() {
        list = realm.objects(TodoModel.self)
            .sorted(byKeyPath: "title", ascending: true)
    }
    
    private func sortByPriority() {
        
    }
    
    @objc private func addButtonClicked() {
        let vc = AddNewViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    override func setHierarchy() {
        view.addSubview(tableView)
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCollectionViewCell.id, for: indexPath) as! HomeCollectionViewCell
        let data = list[indexPath.row]
        cell.titleLabel.text = data.title
        cell.memoLabel.text = data.memo
        cell.dueDateLabel.text = data.dueDate?.formatted()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
//            let data = self.realm.object(ofType: TodoModel.self, forPrimaryKey: self.list[indexPath.row].id)!
            try! self.realm.write {
                self.realm.delete(self.list[indexPath.row])
            }
            tableView.reloadData()
            
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
    
}
