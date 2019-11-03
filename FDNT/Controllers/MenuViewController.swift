//
//  MenuViewController.swift
//  FDNT
//
//  Created by Konrad on 19/09/2019.
//  Copyright © 2019 Konrad. All rights reserved.
//

import UIKit

enum MenuType: Int {
    case FDNT
    case Subtitle1
    case O_Fundacji
    case Nasz_Patron
    case Dla_Darczyńcy
    case Materiały_prasowe
    case Kontakt
}

class MenuViewController: UITableViewController {
    
    @IBOutlet weak var accountView: UIView!
    var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
        
    }
}
