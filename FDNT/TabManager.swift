//
//  Tab.swift
//  FDNT
//
//  Created by Konrad Startek on 30/03/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import Foundation

// MARK: Tab Class
class Tab: Codable {
    let name : String
    let website : String?
    let image : String?
    let isSeparator : Bool?
    
    init(name: String, website: String? = nil, image: String? = nil, isSeparator: Bool? = false) {
        self.name = name
        self.website = website
        self.image = image
        self.isSeparator = isSeparator
    }
}

// MARK: LocalTabs enumeration
enum LocalTabs: String {
    case o_fundacji
    case nasz_patron
    case dla_darczyncy
    case poczta
    //case materialy_prasowe
    case dzieloTV
    case kontakt
    case null
}

// MARK: TabManager class
class TabManager {
    
    // MARK: DefaultTabs class
    class DefaultTabs {
        
        static fileprivate var defaultTabs: [Tab] = [
            Tab(name: "Strona główna", website: "https://dzielo.pl", image: "strona_glowna"),
            Tab(name: "Ogólne", isSeparator: true),
            Tab(name: "O Fundacji", website: "local:o_fundacji", image: "o_fundacji"),
            Tab(name: "Nasz Patron", website: "local:nasz_patron", image: "nasz_patron"),
            Tab(name: "Dla Darczyńcy", website: "local:dla_darczyncy", image: "dla_darczyncy"),
            Tab(name: "Dzieło TV", website: "local:dzieloTV", image: "materialy_prasowe"),
            //Tab(name: "Materiały prasowe", website: "local:materialy_prasowe", image: "materialy_prasowe"),
            Tab(name: "Kontakt", website: "local:kontakt", image: "phone")
        ]
        
        static func getTabs() -> [Tab] {
            return defaultTabs
        }
        
        static func enableEmailTab() {
            if defaultTabs[1].name == "Poczta" {
                return
            }
            let emailTab = Tab(name: "Poczta", website: "local:poczta", image: "email")
            defaultTabs.insert(emailTab, at: 1)
        }
        
        static func disableEmailTab() {
            let tab: Tab = defaultTabs[1]
            if tab.name == "Poczta" {
                defaultTabs.remove(at: 1)
            }
        }
    }
    
    // MARK: CachedTabs class
    class CachedTabs {
        
        static private var cachedTabs: [Tab] = UserDefaults.SavedTabs.getUserTabs()
        
        static func saveTabs(tabs: [Tab]) {
            clearTabs()
            cachedTabs.append(contentsOf: tabs)
            UserDefaults.SavedTabs.setUserTabs(value: tabs)
        }
        
        static func getTabs() -> [Tab] {
            return cachedTabs
        }
        
        static func clearTabs() {
            cachedTabs.removeAll()
            UserDefaults.SavedTabs.clearUserTabs()
        }
    }
    
    // MARK: TabManager.getAllTabs func
    static func getAllTabs() -> [Tab] {
        return Array(DefaultTabs.getTabs() + CachedTabs.getTabs())
    }
}
