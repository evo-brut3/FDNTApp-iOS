//
//  ViewController.swift
//  FDNT
//
//  Created by Konrad on 17/09/2019.
//  Copyright © 2019 Konrad. All rights reserved.
//

import UIKit
import WebKit

class HomeViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet var mainWebView: WKWebView!
    let transition = SlideInTransition()

    override func loadView() {
        super.loadView()
        
        mainWebView = WKWebView(
            frame: CGRect(
                    origin: CGPoint(x: 0, y: 0),
                    size: UIScreen.main.bounds.size
            )
        )
        self.mainWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mainWebView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainWebView.uiDelegate = self
        self.mainWebView.navigationDelegate = self
        mainWebView.load("https://dzielo.pl")
    }
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    func transitionToNew(_ menuType: MenuType) {
        let title = String(describing: menuType).replacingOccurrences(of: "_", with: " ")
        self.title = title
        
        switch menuType {
        case .FDNT:
            mainWebView.load("https://dzielo.pl")
        case .O_Fundacji:
            mainWebView.loadFileURL("o_fundacji")
        case .Nasz_Patron:
            mainWebView.loadFileURL("nasz_patron")
        case .Dla_Darczyńcy:
            mainWebView.loadFileURL("dla_daroczyncy")
        case .Materiały_prasowe:
            mainWebView.loadFileURL("materialy_prasowe")
        case .Kontakt:
            mainWebView.loadFileURL("kontakt")
        default:
            break
        }
    }
}

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
            
            //let request = URLRequest(url: url)
            //load(request)
        }
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
