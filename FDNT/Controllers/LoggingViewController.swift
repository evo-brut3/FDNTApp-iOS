//
//  LoggingViewController.swift
//  FDNT
//
//  Created by Konrad on 27/09/2019.
//  Copyright © 2019 Konrad. All rights reserved.
//

import UIKit

class LoggingViewController: UIViewController {

    @IBOutlet var logOnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.logOnButton.layer.cornerRadius = 5
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
