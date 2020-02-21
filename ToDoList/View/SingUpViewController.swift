//
//  SingUpViewController.swift
//  ToDoList
//
//  Created by Matheus Marcos Maus on 24/10/19.
//  Copyright © 2019 MXM Digital Agency. All rights reserved.
//

import UIKit
import Moya
import CoreData

class SingUpViewController: UIViewController {
    
    struct userInfo: Codable {
        let id: Int
    }
        
    private let storedEmail = "email"
    private let storedPassword = "password"
    private let storedId = "id"
    
    @IBOutlet weak var emailUP: UITextField!
    @IBOutlet weak var passwordUP: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = getLoginDefaults() else { return }
        self.performSegue(withIdentifier: "segueMain", sender: self)
    }
    
    // MARK: - Sign Up  
    
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        let provider = MoyaProvider<TaskRouter>()
        
        let email = self.emailUP.text!
        let password = self.passwordUP.text!
        
        provider.request(.createUser(email, password)) {(result) in
            switch result {
            case .success(let response):
                print(try! response.mapString())
                guard let sameuserInfo = try? response.map(userInfo.self) else { return }
                self.setLoginDefaults(email, password, sameuserInfo.id)
                self.performSegue(withIdentifier: "segueMain", sender: self)
                
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
        defaults.set(id, forKey: self.storedId)
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
