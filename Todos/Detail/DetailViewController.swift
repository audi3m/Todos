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
    
    private var isUpdated = false
    var updated: ((Bool) -> Void)?
    
    private let topStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 15
        return view
    }()
    
    private let dateTagStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 15
        return view
    }()
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 15
        return view
    }()
    
    private let todoImageView = UIImageView()
    
    private let doneButton = UIButton()
    private let titleLabel = UILabel()
    private let spacer = UIView()
    private let flagButton = UIButton()
    
    private let dateLabel = UILabel()
    private let tagLabel = UILabel()
     
    private let memoLabel = UILabel()
    
    init(item: TodoModel) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updated?(isUpdated)
    }
    
    private func setNavBar() {
        navigationItem.title = "상세 화면"
        navigationItem.largeTitleDisplayMode = .never
        
        let edit = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"),
                                   style: .plain, target: self,
                                   action: #selector(editButtonClicked))
        let delete = UIBarButtonItem(image: UIImage(systemName: "trash"),
                                   style: .plain, target: self,
                                   action: #selector(deleteButtonClicked))
        
        navigationItem.rightBarButtonItems = [delete, edit]
    }
    
    override func setHierarchy() {
        view.addSubview(stackView)
        
        topStackView.addArrangedSubview(doneButton)
        topStackView.addArrangedSubview(titleLabel)
        topStackView.addArrangedSubview(spacer)
        topStackView.addArrangedSubview(flagButton)
        
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        dateTagStackView.addArrangedSubview(dateLabel)
        dateTagStackView.addArrangedSubview(tagLabel)
        
        stackView.addArrangedSubview(todoImageView)
        stackView.addArrangedSubview(topStackView)
        stackView.addArrangedSubview(dateTagStackView)
        stackView.addArrangedSubview(memoLabel)
        
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        
        todoImageView.snp.makeConstraints { make in
            make.height.equalTo(250)
        }
        
    }
    
    override func setUI() {
        todoImageView.contentMode = .scaleAspectFill
        todoImageView.layer.cornerRadius = 10
        todoImageView.clipsToBounds = true
        
        doneButton.tintColor = .gray
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        
        flagButton.tintColor = .systemYellow
        flagButton.addTarget(self, action: #selector(flagButtonClicked), for: .touchUpInside)
        
        memoLabel.font = .systemFont(ofSize: 15)
        memoLabel.numberOfLines = 0
        
    }
    
    private func setData() {
        if let image = loadImageFromDocument(filename: "\(item.id)") {
            todoImageView.isHidden = false
            todoImageView.image = image
        } else {
            todoImageView.isHidden = true
        }
        
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let doneImage = UIImage(systemName: item.isDone ? "circle.inset.filled" : "circle", withConfiguration: config)
        doneButton.setImage(doneImage, for: .normal)
        
        let flagImage = UIImage(systemName: item.isFlagged ? "flag.fill" : "flag", withConfiguration: config)
        flagButton.setImage(flagImage, for: .normal)
        
        titleLabel.text = item.title
        
        if item.memo.isEmptyOrWhiteSpace() {
            memoLabel.isHidden = true
        } else {
            memoLabel.isHidden = false
            memoLabel.text = item.memo
        }
    }
    
    @objc private func editButtonClicked() {
        let vc = AddNewViewController()
//        vc.viewModel.inputItem.value = item
        vc.itemToEdit = item
        vc.sendAdded = { added in
            if added {
                self.isUpdated = true
                self.setData()
            }
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        nav.isModalInPresentation = true
        present(nav, animated: true)
    }
    
    @objc private func deleteButtonClicked() {
        showAlertWithChoice(title: "할 일 삭제", message: "\"\(item.title)\" (을/를) 삭제하시겠습니까?", ok: "확인") {
            self.repository.deleteItem(self.item)
            self.isUpdated = true
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func doneButtonClicked() {
        repository.updateIsDone(item)
        updateDoneButtonImage()
        isUpdated = true
    }
    
    @objc private func flagButtonClicked() {
        repository.updateIsFlagged(item)
        updateFlagButtonImage()
        isUpdated = true
    }
    
    private func updateDoneButtonImage() {
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let doneImage = UIImage(systemName: item.isDone ? "circle.inset.filled" : "circle", withConfiguration: config)
        doneButton.setImage(doneImage, for: .normal)
    }
    
    private func updateFlagButtonImage() {
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let flagImage = UIImage(systemName: item.isFlagged ? "flag.fill" : "flag", withConfiguration: config)
        flagButton.setImage(flagImage, for: .normal)
    }
}
