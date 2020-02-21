//
//  ProfileViewController.swift
//  ToDoList
//
//  Created by Matheus Marcos Maus on 24/10/19.
//  Copyright © 2019 MXM Digital Agency. All rights reserved.
//

import UIKit
import Moya
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var welcomingLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
    }
    
    // MARK: - Update User
    
    @IBAction func updateUser(_ sender: Any) {
        
        let provider = MoyaProvider<TaskRouter>()
        
        guard let nome = self.username.text else { return }
        guard let email = self.emailTextField.text else { return }

        let userID = UserDefaults.standard.integer(forKey: "id")
        
        provider.request(.updateUser(userID, email, nome)) {(result) in
            switch result {
            case .success(let response):
                guard 200...299 ~= response.statusCode else {
                    self.responseError(response: response)
                    return
                }

                self.presentMessage(title: "Deu boa!", message: "O seu profile foi atualizado.")
                self.getUser()
            case .failure(let error):
                self.presentError(message: error.localizedDescription)
            }
        }
    }

    struct EmailError: Codable {
        let email: [String]
    }

    func responseError(response: Response) {
        print(try! response.mapString())

        if let error = try? response.map(EmailError.self).email.first {
            self.presentError(message: "Email - " + error)
            return
        }

        self.presentError(message: "Erro inesperado")
    }

    func getUser() {
        let userID = UserDefaults.standard.integer(forKey: "id")
        let provider = MoyaProvider<TaskRouter>()

        provider.request(.getUser(userID)) {(result) in
            switch result {
            case .success(let response):
                guard 200...299 ~= response.statusCode else {
                    self.responseError(response: response)
                    return
                }

                self.getUserSuccess(response: response)

            case .failure(let error):
                self.presentError(message: error.localizedDescription)
            }
        }
    }

    struct Profile: Codable {
        let name: String?
    }

    func getUserSuccess(response: Response) {
        print(try! response.mapString())

        var name = try? response.map(Profile.self).name

        if name == nil || name!.isEmpty {
            name = "@usuário"
        }

        welcomingLabel.text = welcomingString(name: name!)
    }

    func welcomingString(name: String) -> String {
        return "Olá \(name)! 👋"
    }
}
