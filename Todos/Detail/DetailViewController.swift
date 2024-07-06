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
        navigationItem.title = item.title
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    override func setHierarchy() {
        view.addSubview(todoImageView)
        view.addSubview(titleLabel)
    }
    
    override func setLayout() {
        todoImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(todoImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func setUI() {
        if let image = loadImageFromDocument(filename: "\(item.id)") {
            todoImageView.image = image
        }
        
        todoImageView.contentMode = .scaleAspectFill
        todoImageView.clipsToBounds = true
        
        titleLabel.text = item.title
    }
    
    
    
    
}
