//
//  UserDefaults+tabsGetSetClear.swift
//  FDNT
//
//  Created by Konrad Startek on 03/09/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import Foundation

extension UserDefaults {

    class SavedTabs {
        
        static let key = "savedTabs"
        
        // MARK: Save User Tabs
        static func setUserTabs(value: [Tab]) {
            if let encodedTabs = try? PropertyListEncoder().encode(value) {
                UserDefaults.standard.set(encodedTabs, forKey: key)
                print("app folder path is \(NSHomeDirectory())")
            }
        }
        
        // MARK: Retrieve User Tabs
        static func getUserTabs() -> [Tab] {
            if let decodedData = UserDefaults.standard.data(forKey: key) {
                let tabs = try! PropertyListDecoder().decode([Tab].self, from: decodedData)
                return tabs
            } else {
                return []
            }
            
        }
        
        // MARK: Remove all User Tabs
        static func clearUserTabs() {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
