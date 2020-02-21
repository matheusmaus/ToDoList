//
//  TaskRouter.swift
//  ToDoList
//
//  Created by Matheus Marcos Maus on 31/10/19.
//  Copyright © 2019 MXM Digital Agency. All rights reserved.
//

import Foundation
import Moya

enum TaskRouter {
    
    case createUser(_ email: String, _ password: String)
    case login(_ email: String, _ password: String)
    case getUser(_ id: Int)
    case updateUser(_ id: Int, _ email: String, _ nome: String)
    case addTask(_ id: Int, _ taskName: String)
    case deleteTask(_ taskID: Int)
    case userTask(_ taskID: Int)
    
}

extension TaskRouter: TargetType {
    var baseURL: URL {
        return URL(string: "http://mxmdigital.co")!
    }
    
    var path: String {
        switch self {
        case .createUser:
            return "/api/signup_user"
        case .login:
            return "/usuario/login.json"
        case .getUser:
            return "/api/user_by_id"
        case .updateUser:
            return "/api/update_user"
        case .addTask:
            return "/api/create_task"
        case .deleteTask:
            return "/api/delete_task"
        case .userTask:
            return "/api/tasks"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createUser:
            return .post
        case .login:
            return .post
        case .getUser:
            return .get
        case .updateUser:
            return .post
        case .addTask:
            return .post
        case .deleteTask:
            return .post
        case .userTask:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .createUser (let email, let password):
            let parameters = ["email": email, "password": password]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .login (let email, let password):
            let userInfo = ["email": email, "password": password]
            let parameters = ["user": userInfo]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .getUser (let id):
            let parameters = ["id": id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .updateUser (let id, let email, let nome):
            let parameters = ["id": id, "email": email, "name": nome] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .addTask (let id, let taskName):
            let parameters: [String: Any] = ["user_id": id, "title": taskName]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .deleteTask (let taskID):
            let parameters = ["id": taskID]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .userTask (let id):
            let parameters = ["id": id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
