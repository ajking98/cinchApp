//
//  SQLStruct.swift
//  Cards
//
//  Created by Ahmed Gedi on 6/16/19.
//

import Foundation


struct SQLStruct {
    var database: Connection!
    let usersTable = Table("users")
    let id = Expression<Int>("id")
    let name = Expression<String?>("name")
    let email = Expression<String?>("email")
    let password = Expression<String?>("password")
    let isPrivate = Expression<Bool?>("isPrivate")
    
    func createTable() {
        print("Create Table")
        
        let createTable = self.usersTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email)
            table.column(self.password)
            table.column(self.isPrivate)
            //            table.column(self.profilePic)
            //            table.column(self.dateCreated)
            //            table.column(self.dateLastActive)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
        
    }
    
    func insertUser() {
        let uuid = UIDevice.current.identifierForVendor!
        print("Insert User")
        ParentStruct().readUser(user: uuid.uuidString, completion: { (userInfo:User, dateCreated:String, dateLastActive:String, folders:Any) in
            print("printing userhh: ", userInfo)
            print("printing name: ", userInfo.name!)
            print("printing password: ", userInfo.password!)
            let insertUser = self.usersTable.insert(self.name <- userInfo.name!, self.email <- userInfo.email!, self.password <- userInfo.password!, self.isPrivate <- userInfo.isPrivate! )
            
            do {
                try self.database.run(insertUser)
                print("Inserted User ")
            } catch {
                print(error)
            }
        })
        
        
    }
    
    
    func listUsers() {
        print("List Users")
        
        do {
            let users = try self.database.prepare(usersTable)
            for user in users {
                print("userID: \(user[self.id]), name: \(String(describing: user[self.name]!)), email: \(String(describing: user[self.email]!)), password: \(String(describing: user[self.password]!)), isPrivate: \(String(describing: user[self.isPrivate]!))" )
            }
        } catch {
            print(error)
        }
    }
    
    func updateUser(_ sender: Any) {
        print("Update User")
        let alert = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "User ID" }
        alert.addTextField { (tf) in tf.placeholder = "Email" }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let userIdString = alert.textFields?.first?.text,
                let userId = Int(userIdString),
                let email = alert.textFields?.last?.text
                else { return }
            print(userIdString)
            print(email)
            
            let user = self.usersTable.filter(self.id == userId)
            let updateUser = user.update(self.email <- email)
            do {
                try self.database.run(updateUser)
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteUser(userId:Int) {
        print("Delete User")
        let user = self.usersTable.filter(self.id == userId)
        let deleteUser = user.delete()
        do {
            try self.database.run(deleteUser)
        } catch {
            print(error)
        }
    }
}
