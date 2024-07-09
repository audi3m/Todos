//
//  FolderViewController.swift
//  Todos
//
//  Created by J Oh on 7/9/24.
//

import UIKit
import RealmSwift

final class FolderViewController: BaseViewController {
    
    var folder: Folder!
    var list: Results<TodoModel>!
    let todoRepository = TodoRepository()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    func fetchData() {
        list = todoRepository.fetchByFolder(folder: folder)
        
        tableView.reloadData()
    }
    
    private func setNavBar() {
        navigationItem.title = folder?.name
        
        let plus = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewTodo))
        navigationItem.rightBarButtonItem = plus
        
    }
    
    override func setHierarchy() {
        view.addSubview(tableView)
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setUI() {
        
    }
    
    @objc private func addNewTodo() {
        let vc = AddNewViewController()
        vc.folder = folder
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        nav.isModalInPresentation = true
        present(nav, animated: true)
    }
    
    
}

extension FolderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        let data = list[indexPath.row]
        cell.textLabel?.text = data.title
        
        
        
        return cell
    }
    
    
}
