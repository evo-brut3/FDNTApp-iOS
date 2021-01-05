//
//  PreferencesTableViewCell.swift
//  FDNT
//
//  Created by Konrad on 07/09/2020.
//  Copyright © 2020 Konrad. All rights reserved.
//

import UIKit

class PreferencesTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
    }
}
