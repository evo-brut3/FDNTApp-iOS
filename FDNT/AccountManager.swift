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
    
    public private(set) var userName : String?
    public private(set) var userEmail : String? = Auth.auth().currentUser?.email!
    
    func signIn(email: String, pass: String, completion: @escaping (Error?) -> ()) {
        self.singOut()
        
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] (result, error) in
            guard self != nil else { return }
        
            if error == nil {
                self!.userName = self!.extractUserName(email: email)
                self!.userEmail = email
            } else {
                print(error as Any)
            }
            
            completion(error)
        }
    }
    
    func singOut() {
        try! Auth.auth().signOut()
        
        self.userName = nil
        self.userEmail = nil
        
        TabAPI.resetUserTabs()
    }
    
    func isSigned() -> Bool {
        if Auth.auth().currentUser != nil {
            print("Signed in")
            return true
        } else {
            print("Not signed in")
            return false
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
