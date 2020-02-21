//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Matheus Marcos Maus on 24/10/19.
//  Copyright © 2019 MXM Digital Agency. All rights reserved.
//

import UIKit
import Moya
import CoreData

class TaskViewController: UIViewController {
    
    @IBOutlet weak var taskName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Add Task

    @IBAction func addTaskBtn(_ sender: Any) {
        let provider = MoyaProvider<TaskRouter>()

        guard let taskName = self.taskName.text else { return }

        let userID = UserDefaults.standard.integer(forKey: "id")

        provider.request(.addTask(userID, taskName)) {(result) in
            switch result {
            case .success(_):
                self.dismiss(animated: true)
            case .failure(let error):
                self.presentError(message: error.errorDescription)
            }
        }
    }
}

extension UIViewController {
    func presentMessage(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))

        present(alert, animated: true)
    }

    func presentError(message: String?) {
        presentMessage(title: "Erro", message: message)
    }
}
