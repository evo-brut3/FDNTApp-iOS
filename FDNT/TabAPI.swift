//
//  Tab.swift
//  FDNT
//
//  Created by Konrad on 30/03/2020.
//  Copyright © 2020 Konrad. All rights reserved.
//

import Foundation

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}


struct Tab {
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

class TabAPI {
    static private let defaultUserTabs : [Tab] = [
        Tab(name: "Strona główna", website: "https://dzielo.pl", image: "strona_glowna"),
        Tab(name: "Ogólne", isSeparator: true),
        Tab(name: "O Fundacji", website: "local:o_fundacji", image: "o_fundacji"),
        Tab(name: "Nasz Patron", website: "local:nasz_patron", image: "nasz_patron"),
        Tab(name: "Dla Darczyńcy", website: "local:dla_darczyncy", image: "dla_darczyncy"),
        Tab(name: "Materiały prasowe", website: "local:materialy_prasowe", image: "materialy_prasowe"),
        Tab(name: "Kontakt", website: "local:kontakt", image: "kontakt"),
        Tab(name: "Twoje zakładki", isSeparator: true)
    ]
    
    static private var userTabs : [Tab] = defaultUserTabs
    
    static func getUserTabs() -> [Tab] {
        return userTabs
    }
    
    static func addUserTab(tab: Tab) {
        userTabs.append(tab)
    }
    
    static func resetUserTabs() {
        userTabs.removeAll()
        userTabs.append(contentsOf: defaultUserTabs)
    }
}
