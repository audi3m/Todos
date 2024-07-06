//
//  DetailViewController.swift
//  Todos
//
//  Created by J Oh on 7/4/24.
//

import UIKit
import SnapKit

final class DetailViewController: BaseViewController {
    
    let repository = TodoRepository()
    let item: TodoModel
    
    let todoImageView = UIImageView()
    let titleLabel = UILabel()
    
    init(item: TodoModel) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setHierarchy() {
        
    }
    
    override func setLayout() {
        
    }
    
    override func setUI() {
        
    }
    
    
    
    
}
