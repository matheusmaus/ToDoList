//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Matheus Marcos Maus on 24/10/19.
//  Copyright © 2019 MXM Digital Agency. All rights reserved.
//

import UIKit
import Moya
import CoreData

class ToDoTableViewController: UITableViewController {

    struct Task: Codable {
        let title: String
        let id: Int
    }

    struct UserInfo: Codable {
        let id: Int
    }

  var tasks = [Task]()

  override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let spinner = UIActivityIndicatorView(style: .gray)
        self.tableView.tableFooterView = spinner
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let provider = MoyaProvider<TaskRouter>()
        
        let userID = UserDefaults.standard.integer(forKey: "id")

        provider.request(.userTask(userID)) {(result) in
              switch result {
              case .success(let response):
                  print(try! response.mapString())
                  guard let tasks = try? response.map([Task].self) else { return }
                  self.tasks = tasks
                  self.tableView.reloadData()
                  
              case .failure(let error):
                  print(error.localizedDescription)
              }
          }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
      cell.textLabel?.text = tasks[indexPath.row].title
      return cell
  }
    
    // MARK: - Swipes + Excluir
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let ignore = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration (actions: [ignore])
    }

    func deleteAction (at indexPath: IndexPath) -> UIContextualAction {

        let action = UIContextualAction(style: .destructive, title: "Excluir") { (action, view, completion) in
            self.deleteTask(at: indexPath.row)
            completion(true)
        }

        action.backgroundColor = .red

        return action
    }

    func deleteTask(at index: Int) {
        let provider = MoyaProvider<TaskRouter>()

        provider.request(.deleteTask(tasks[index].id)) {(result) in
            switch result {
            case .success(_):
                self.tasks.remove(at: index)
                self.tableView.reloadData()

            case .failure(let error):
                self.presentError(message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func showAddTask(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(identifier: "TaskViewController") as! TaskViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
