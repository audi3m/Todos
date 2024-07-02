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
    
    let tableView = UITableView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        
        
        
    }
    
    
    private func setNavBar() {
        let menu = UIBarButtonItem(image: .menu, style: .plain, target: self,
                                   action: #selector(menuButtonClicked))
        
        navigationItem.rightBarButtonItem = menu
    }
    
    @objc private func menuButtonClicked() {
        
    }
    
    override func setHierarchy() {
        
    }
    
    override func setLayout() {
        
    }
    
    override func setUI() {
        
    }
    
    
}

