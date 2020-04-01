//
//  AccountManager.swift
//  FDNT
//
//  Created by Konrad on 22/03/2020.
//  Copyright © 2020 Konrad. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class AccountManager {
    
    static let shared = AccountManager()
    private var ref = Database.database().reference() as DatabaseReference?
    
    private init() {
        print("Initialized AccountManager")
    }
    
    private var userName : String!
    private var userEmail : String!
    private var userPass : String!
    
    func signIn(email: String, pass: String, completion: @escaping (Error?) -> ()) {
        try! Auth.auth().signOut()
        
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] (result, error) in
            guard self != nil else { return }
        
            self!.userName = self!.extractUserName(email: email)
            self!.userEmail = email
            self!.userPass = pass
            
            completion(error)
        }
    }
    
    private func extractUserName(email: String) -> String {
        let index = email.range(of: "@")?.lowerBound
        let name = String(email.prefix(upTo: index!).replacingOccurrences(of: ".", with: ""))
        return name
    }
    
    func collectUserTables(completion: @escaping ([String : String]) -> ()) {
        var userTabs = [String : String]()
        self.ref!.child("users").child(self.userName!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary

            if (value != nil) {
                let values = DispatchGroup()
                
                for (v) in value!.allKeys {
                    values.enter()
                    let tabName = v as? String ?? "null"
                    self.getTabAdressByName(tabName: tabName, completion: { (result) in
                        userTabs[tabName] = result
                        values.leave()
                    })
                }
                
                values.notify(queue: .main) {
                    completion(userTabs)
                }
            }
            
        }) { (error) in
            print("Error has occurred")
        }
    }
    
    private func getTabAdressByName(tabName: String, completion: @escaping (String) -> ()) {
        self.ref!.child("tabs").child(tabName).child("site").observeSingleEvent(of: .value, with: { (snapshot) in
            let tabURL = snapshot.value as? String
            completion(tabURL ?? "null")
        }) { (error) in
            print("Error has occurred")
            completion("null")
            }
    }
}
