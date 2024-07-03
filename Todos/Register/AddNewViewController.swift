//
//  AddNewViewController.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class AddNewViewController: BaseViewController {
    weak var delegate: AddItemViewControllerDelegate?
    
    let tableView = UITableView()
    
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
         
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func addButtonClicked() {
        let titleCell = tableView.visibleCells.first as! TitleMemoTableViewCell
        let text = titleCell.titleTextField.text!
        
        if text.isEmpty {
            showAlert(title: "제목을 입력해주세요", message: "제목은 필수입니다.", ok: "확인") {
                
            }
        } else {
            let realm = try! Realm()
            let data = TodoModel(title: text, memo: "메모", dueDate: .now, priority: Int.random(in: 1...3))
            try! realm.write {
                realm.add(data)
                print("Realm Save Success")
            }
            delegate?.didAddNewItem(true)
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
            vc.date = { date in
                print(date.customFormat())
            }
            navigationController?.pushViewController(vc, animated: true)
        case .tag:
            let vc = TagViewController()
            vc.tag = { tag in
                print(tag)
            }
            navigationController?.pushViewController(vc, animated: true)
        case .priority:
            let vc = PriorityViewController()
            vc.priority = { priority in
                print(priority)
            }
            navigationController?.pushViewController(vc, animated: true)
        case .addImage:
            let vc = ImageSelectViewController()
            
            navigationController?.pushViewController(vc, animated: true)
        default: break
        }
        
        
//        if let vc = attribute.viewController {
//            vc.data = { value in
//                self.moneyButton.setTitle(value, for: .normal)
//            }
//            navigationController?.pushViewController(vc, animated: true)
//        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
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

protocol AddItemViewControllerDelegate: AnyObject {
    func didAddNewItem(_ added: Bool)
}
