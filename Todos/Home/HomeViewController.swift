//
//  ViewController.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
    
     let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeCollectionViewCell.self, forCellReuseIdentifier: HomeCollectionViewCell.id)
        
    }
    
    private func setNavBar() {
        navigationItem.title = "목록"
        let add = UIBarButtonItem(image: .plus, style: .plain, target: self, action: #selector(addButtonClicked))
        let menu = UIBarButtonItem(image: .menu, style: .plain, target: self, action: #selector(menuButtonClicked))
        navigationItem.leftBarButtonItem = add
        navigationItem.rightBarButtonItem = menu
         
    }
    
    @objc private func menuButtonClicked() {
        
    }
    
    @objc private func addButtonClicked() {
        
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
    
    
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCollectionViewCell.id, for: indexPath) as! HomeCollectionViewCell
        cell.titleLabel.text = "제목 자리입니다."
        cell.memoLabel.text = "Memo 자리입니다."
        cell.dueDateLabel.text = "Date 자리입니다."
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
}
