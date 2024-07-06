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
    let titleLabel = PaddedLabel()
    let memoLabel = PaddedLabel()
    
    init(item: TodoModel) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "상세 화면"
        navigationItem.largeTitleDisplayMode = .never
        
        setData()
        
    }
    
    override func setHierarchy() {
        view.addSubview(todoImageView)
        view.addSubview(titleLabel)
        view.addSubview(memoLabel)
    }
    
    override func setLayout() {
        todoImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(todoImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func setUI() {
        
        
        todoImageView.contentMode = .scaleAspectFill
        todoImageView.clipsToBounds = true
        
        titleLabel.text = item.title
        
        memoLabel.font = .systemFont(ofSize: 15)
        memoLabel.numberOfLines = 0
        
        
    }
    
    func setData() {
        if let image = loadImageFromDocument(filename: "\(item.id)") {
            todoImageView.image = image
        } else {
            todoImageView.isHidden = true
        }
        
        if let memo = item.memo {
            memoLabel.text = memo
            memoLabel.isHidden = false
        } else {
            memoLabel.isHidden = true
        }
    }
    
}
