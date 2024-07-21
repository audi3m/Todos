//
//  FolderViewController.swift
//  Todos
//
//  Created by J Oh on 7/9/24.
//

import UIKit
import RealmSwift

final class FolderViewController: BaseViewController {
    
    var folder: Folder
    var list: Results<TodoModel>!
    let todoRepository = TodoRepository()
    let folderRepository = FolderRepository()
    
    lazy private var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    var isUpdated: ((Bool) -> Void)?
    var updated = false
    
    init(folder: Folder) {
        self.folder = folder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isUpdated?(updated)
    }
    
    func fetchData() {
        list = todoRepository.fetchByFolder(folder: folder)
        tableView.reloadData()
    }
    
    private func setNavBar() {
        navigationItem.title = folder.name
        navigationItem.largeTitleDisplayMode = .never
        
        let plus = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewTodo))
        let delete = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteFolder))
        navigationItem.rightBarButtonItems = [plus, delete]
        
    }
    
    override func setHierarchy() {
        view.addSubview(tableView)
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
     
    @objc private func deleteFolder() {
        showAlertWithChoice(title: "폴더를 삭제하시겠습니까?", message: "폴더 안에 있는 아이템들도 모두 삭제됩니다.", ok: "삭제") { [weak self] in
            guard let self else { return }
            self.folderRepository.deleteFolder(self.folder)
            updated = true
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func addNewTodo() {
        let vc = AddNewViewController()
        vc.folder = folder
        vc.sendAdded = { added in
            if added {
                self.tableView.reloadData()
                self.updated = true
            }
        }
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
