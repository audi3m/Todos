//
//  AddNewViewController.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import PhotosUI
import SnapKit

final class AddNewViewController: BaseViewController {
    
    let viewModel = ItemViewModel()
    var newOrOldItem: TodoModel?
    
    private let tableView = UITableView()
    var newTodo = TodoModel()
    var sendAdded: ((Bool) -> Void)?
    var itemToEdit: TodoModel?
    var folder: Folder?
     
    var selectedImage: UIImage?
    
    private var notAppeared = true
    
    let todoRepository = TodoRepository()
    let folderRepository = FolderRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setValuesForEditMode(item: itemToEdit)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TitleMemoTableViewCell.self, forCellReuseIdentifier: TitleMemoTableViewCell.id)
        tableView.register(AddNewTableViewCell.self, forCellReuseIdentifier: AddNewTableViewCell.id)
        
        bindData()
    }
    
    private func bindData() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if notAppeared {
            setValuesForEditMode(item: itemToEdit)
            notAppeared = false
        }
    }
    
    private func setNavBar() {
        navigationItem.title = itemToEdit == nil ? "새로운 할 일" : "편집"
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        let add = UIBarButtonItem(title: itemToEdit == nil ? "추가" : "완료", style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = add 
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
        view.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.keyboardDismissMode = .onDrag
    }
    
    @objc private func cancelButtonClicked() {
        sendAdded?(false)
        dismiss(animated: true)
    }
    
    @objc private func addButtonClicked() {
        let titleCell = tableView.visibleCells.first as! TitleMemoTableViewCell
        let title = titleCell.titleTextField.text!
        let memo = titleCell.memoTextField.text!
        guard title.isEmpty else {
            showAlert(title: "제목을 입력해주세요", message: "제목은 필수입니다.", ok: "확인") { }
            return
        }
        
//        viewModel.inputTitle.value = title
//        viewModel.inputMemo.value = memo
        
        newTodo.title = title
        newTodo.memo = memo
        
        // 편집
        if let item = self.itemToEdit {
            todoRepository.updateItem(item, with: newTodo)
            if let toDoImage = self.selectedImage {
                saveImageToDocument(image: toDoImage, filename: "\(item.id)")
            }
        } else {
            // 새로운 할 일
            if let folder {
                folderRepository.addItem(folder, newTodo: newTodo)
            }
            todoRepository.createItem(newTodo)
            if let toDoImage = self.selectedImage {
                saveImageToDocument(image: toDoImage, filename: "\(newTodo.id)")
            }
        }
        
        sendAdded?(true)
        dismiss(animated: true)
        
    }
}

extension AddNewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Attributes.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleMemoTableViewCell.id, for: indexPath) as! TitleMemoTableViewCell
            if let itemToEdit {
                cell.titleTextField.text = itemToEdit.title
                cell.memoTextField.text = itemToEdit.memo
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddNewTableViewCell.id, for: indexPath) as! AddNewTableViewCell
            let text = Attributes.allCases[indexPath.row].rawValue 
            cell.attributeLabel.text = text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let attribute = Attributes.allCases[indexPath.row]
        switch attribute {
        case .dueDate:
            let vc = DueDateViewController()
            var currentDate = itemToEdit?.dueDate
            vc.datePicker.date = currentDate ?? .now
            vc.sendDate = { date in
                currentDate = date
                self.newTodo.dueDate = currentDate
                self.updateLabel(for: indexPath, with: currentDate?.customFormat() ?? nil)
            }
            navigationController?.pushViewController(vc, animated: true)
        case .tag:
            let vc = TagViewController()
            if let itemToEdit {
                vc.tagTextField.text = itemToEdit.tag
            }
            vc.sendTag = { tag in
                self.newTodo.tag = tag
                self.updateLabel(for: indexPath, with: tag)
            }
            navigationController?.pushViewController(vc, animated: true)
        case .priority:
            let vc = PriorityViewController()
            if let itemToEdit {
                vc.selectedPriority = Priority(rawValue: itemToEdit.priority) ?? .none
            }
            vc.sendPriority = { priority in
                self.newTodo.priority = priority.rawValue
                if priority == .none {
                    self.updateLabel(for: indexPath, with: nil)
                } else {
                    self.updateLabel(for: indexPath, with: priority.stringValue)
                }
            }
            navigationController?.pushViewController(vc, animated: true)
        case .addImage:
            if itemToEdit != nil { }
            addImageCellClicked()
        default: break
        }
    }
    
    private func setValuesForEditMode(item: TodoModel?) {
        guard let item else { return }
        self.updateLabel(for: IndexPath(row: 1, section: 0), with: item.dueDate?.customFormat())
        self.updateLabel(for: IndexPath(row: 2, section: 0), with: item.tag)
        self.updateLabel(for: IndexPath(row: 3, section: 0), with: Priority(rawValue: item.priority)?.stringValue)
        if let image = loadImageFromDocument(filename: "\(item.id)"),
           let cell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? AddNewTableViewCell {
            selectedImage = image
            cell.attributeValueLabel.isHidden = true
            cell.selectedImageView.isHidden = false
            cell.selectedImageView.image = image
        }
    }
    
    private func addImageCellClicked() {
        print(#function)
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.screenshots, .images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func updateLabel(for indexPath: IndexPath, with value: String?) {
        if let cell = tableView.cellForRow(at: indexPath) as? AddNewTableViewCell {
            if let value {
                cell.setAttributeValue(type: .hasValue(value: value))
            } else {
                cell.setAttributeValue(type: .none)
            }
        }
    }
     
    private enum Attributes: String, CaseIterable {
        case titleAndMemo
        case dueDate = "마감일"
        case tag = "태그"
        case priority = "우선 순위"
        case addImage = "이미지 선택"
        
        var viewController: UIViewController? {
            switch self {
            case .dueDate:
                return DueDateViewController()
            case .tag:
                return TagViewController()
            case .priority:
                return PriorityViewController()
            default:
                return nil
            }
        }
    }
}

extension AddNewViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                self.selectedImage = image as? UIImage
                DispatchQueue.main.async {
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? AddNewTableViewCell {
                        cell.attributeValueLabel.isHidden = true
                        cell.selectedImageView.isHidden = false
                        cell.selectedImageView.image = image as? UIImage
                    }
                }
            }
        }
    }
}

extension AddNewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
