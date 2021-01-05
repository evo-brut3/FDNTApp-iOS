//
//  UIViewController+subviewAddRemove.swift
//  FDNT
//
//  Created by Konrad Startek on 03/09/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import Foundation
import UIKit

// MARK: UIViewController extension - add and remove subview
@nonobjc extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        child.view.frame = frame ?? self.view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
