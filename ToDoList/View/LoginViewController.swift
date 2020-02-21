//
//  LoginViewController.swift
//  ToDoList
//
//  Created by Matheus Marcos Maus on 24/10/19.
//  Copyright © 2019 MXM Digital Agency. All rights reserved.
//

import UIKit
import Moya
import CoreData

class LoginViewController: UIViewController {
    
    struct userInfo:Codable {
        var id: Int
    }
        
    private let storedEmail = "email"
    private let storedPassword = "password"
    
    @IBOutlet weak var emailIN: UITextField!
    @IBOutlet weak var passwordIN: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = getLoginDefaults() {
          presentLogin()
        }
    }
    
    // MARK: - Sign In

    func presentLogin() {
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "ToDoTableViewController")
      guard let todoTableViewController = vc as? ToDoTableViewController else { return }
      todoTableViewController.modalPresentationStyle = .fullScreen
      self.present(todoTableViewController, animated: true)
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        
        let provider = MoyaProvider<TaskRouter>()
        
        let email = self.emailIN.text!
        let password = self.passwordIN.text!
        
        provider.request(.login(email, password)) {(result) in
            switch result {
            case .success(let response):
                print(try! response.mapString())
                
                let sameuserInfo = try! response.map(userInfo.self)
                print(sameuserInfo.id)

                self.setLoginDefaults(email, password, sameuserInfo.id)

                DispatchQueue.main.async {
                  self.presentLogin()
                }
              
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Login Defaults
    
  public func setLoginDefaults(_ email: String, _ password: String, _ id: Int) {
      let defaults = UserDefaults.standard
      defaults.set(email, forKey: self.storedEmail)
      defaults.set(password, forKey: self.storedPassword)
      defaults.set(id, forKey: "id")
  }
    
    public func getLoginDefaults() -> Login? {
        let defaults = UserDefaults.standard
        if let email: String = defaults.string(forKey: self.storedEmail) {
            if let password: String = defaults.string(forKey: self.storedPassword) {
                var res = Login()
                res.email = email
                res.password = password
                
                return res
            }
        }
        
        return nil
    }
    
}

