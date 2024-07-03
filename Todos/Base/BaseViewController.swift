//
//  BaseViewController.swift
//  Todos
//
//  Created by J Oh on 7/2/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
         
        setHierarchy()
        setLayout()
        setUI()
    }
    
    func setHierarchy() { }
    func setLayout() { }
    func setUI() { }
    
    func showAlert(title: String, message: String, ok: String, handler: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: ok, style: .default) { _ in
            handler()
        }
        
//        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
//        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
}
