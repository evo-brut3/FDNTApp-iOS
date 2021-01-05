//
//  ViewController.swift
//  FDNT
//
//  Created by Konrad Startek on 17/09/2019.
//  Copyright © 2019 Konrad Startek. All rights reserved.
//

import UIKit
import WebKit

class HomeViewController: UIViewController, UIViewControllerTransitioningDelegate, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet var mainWebView: WKWebView!
    @IBOutlet var mainView: UIView!
    
    let transition = SlideInTransition()
    static var currentUserTabIndex: Int = 0
    private var currentTabView: UIViewController? = nil
    
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
        self.transitionToNew(3)
    }
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let SidebarViewController = storyboard?.instantiateViewController(withIdentifier: "SidebarViewController") as? SidebarTableViewController else { return }
        SidebarViewController.didTapMenuType = { (index) in
            self.transitionToNew(index)
        }
        
        SidebarViewController.modalPresentationStyle = .overCurrentContext
        SidebarViewController.transitioningDelegate = self
        present(SidebarViewController, animated: true)
    }
    
    func transitionToNew(_ index: Int) {
        let userTabs = TabManager.getAllTabs()
        
        if var siteURL = userTabs[index].website {
            HomeViewController.currentUserTabIndex = index
            self.title = userTabs[index].name
            
            if siteURL.substring(to: 6) == "local:" {
                siteURL = siteURL.substring(from: 6)
                let localTab = LocalTabs(rawValue: siteURL) ?? LocalTabs.null
                
                mainWebView.isHidden = true
                changeScreenToLocalTab(tab: localTab)
                //mainWebView.loadFileURL(siteURL)
            } else {
                mainWebView.isHidden = false
                currentTabView?.remove()
                mainWebView.load(siteURL)
            }
            
            print("LOADING: \(siteURL)")
        }
    }
    
    // MARK: Change current screen to Local Tab
    func changeScreenToLocalTab(tab: LocalTabs) {
        currentTabView?.remove()
        //currentTabView?.dismiss(animated: true)
        currentTabView = nil
        
        switch tab {
        case .poczta:
            currentTabView = storyboard?.instantiateViewController(withIdentifier: "EmailTableViewController") as? EmailTableViewController
        case .o_fundacji:
            currentTabView = storyboard?.instantiateViewController(withIdentifier: "AboutFoundationViewController") as? AboutFoundationViewController
        case .nasz_patron:
            currentTabView = storyboard?.instantiateViewController(withIdentifier: "OurPatronViewController") as? OurPatronViewController
        case .dla_darczyncy:
            currentTabView = storyboard?.instantiateViewController(withIdentifier: "ForDonorViewController") as? ForDonorViewController
        case .dzieloTV:
            let ytID = "UCxkYQabJ4QQ12FHqhSXEUQw"
            
            if let appURL = URL(string: "youtube://channel/\(ytID)"), UIApplication.shared.canOpenURL(appURL) {
                print("CAN INTO APP URL")
                UIApplication.shared.open(appURL)
            } else if let webURL = URL(string: "https://www.youtube.com/channel/\(ytID)") {
                UIApplication.shared.open(webURL)
            }
            
            self.transitionToNew(3)
        case .kontakt:
            currentTabView = storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as? ContactViewController
        default:
            print(0)
        }
        
        if currentTabView != nil {
            add(currentTabView!)
        }
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
