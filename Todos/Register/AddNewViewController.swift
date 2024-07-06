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
    
    let tableView = UITableView()
    var newTodo = TodoModel()
    var sendAdded: ((Bool) -> Void)?
    
    var toDoImage: UIImage?
    
    let repository = TodoRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TitleMemoTableViewCell.self, forCellReuseIdentifier: TitleMemoTableViewCell.id)
        tableView.register(AddNewTableViewCell.self, forCellReuseIdentifier: AddNewTableViewCell.id)
        
    }
    
    private func setNavBar() {
        navigationItem.title = "새로운 할 일"
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClicked))
        let add = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
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
    
    @objc func cancelButtonClicked() {
        sendAdded?(false)
        dismiss(animated: true)
    }
    
    @objc func addButtonClicked() {
        let titleCell = tableView.visibleCells.first as! TitleMemoTableViewCell
        let title = titleCell.titleTextField.text!
        let memo = titleCell.memoTextField.text!
        newTodo.title = title
        newTodo.memo = memo
         
        if title.isEmpty {
            showAlert(title: "제목을 입력해주세요", message: "제목은 필수입니다.", ok: "확인") { }
        } else {
            repository.createItem(newTodo)
            if let toDoImage {
                saveImageToDocument(image: toDoImage, filename: "\(newTodo.id)")
            }
            sendAdded?(true)
            dismiss(animated: true)
        }
    }
     
}

extension AddNewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Attributes.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleMemoTableViewCell.id, for: indexPath) as! TitleMemoTableViewCell
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
            vc.sendDate = { date in
                self.newTodo.dueDate = date
                self.updateLabel(for: indexPath, with: date?.customFormat())
            }
            navigationController?.pushViewController(vc, animated: true)
        case .tag:
            let vc = TagViewController()
            vc.sendTag = { tag in
                self.newTodo.tag = tag
                self.updateLabel(for: indexPath, with: tag)
            }
            navigationController?.pushViewController(vc, animated: true)
        case .priority:
            let vc = PriorityViewController()
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
            addImageCellClicked()
        default: break
        }
        
    }
    
    func addImageCellClicked() {
        print(#function)
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.screenshots, .images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func updateLabel(for indexPath: IndexPath, with value: String?) {
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
            case .addImage:
                return ImageSelectViewController()
            default:
                return nil
            }
        }
    }
}

extension AddNewViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                self.toDoImage = image as? UIImage
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


