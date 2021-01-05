//
//  WKWebView+loadURL.swift
//  FDNT
//
//  Created by Konrad Startek on 03/09/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import Foundation
import WebKit

// MARK: WKWebView extension - load pages
extension WKWebView {
    
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
   
    func loadFileURL(_ fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "html", subdirectory: "LocalPages") {
            loadFileURL(url, allowingReadAccessTo:
                url.deletingLastPathComponent())
        }
    }
}
