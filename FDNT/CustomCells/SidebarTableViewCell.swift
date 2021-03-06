//
//  SidebarCellViewController.swift
//  FDNT
//
//  Created by Konrad Startek on 29/03/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

class SidebarTableViewCell: UITableViewCell {

    var tabIndex : Int = -1
    static var selectedTab : SidebarTableViewCell? = nil
    
    var tab : Tab? {
        didSet {
            guard let tabItem = tab else { return }
            cellLabel.text = tabItem.name
            
            if let website = tabItem.website {
                
            }
            
            if let image = tabItem.image {
                
            }
            
            if tabItem.isSeparator == true {
                separatorLineView.isHidden = false
                
                cellLabel.textColor = .darkGray
                cellLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0).isActive = true
                selectionStyle = UITableViewCell.SelectionStyle.none
                isUserInteractionEnabled = false
            } else {
                let image = tabItem.image
                cellImageView.image = UIImage(named: image ?? "strona_glowna")/*?.resizableImage(withCapInsets: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0))*/
                //cellImageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
                //cellImageView.frame = CGRect(0, 0)
                cellLabel.leadingAnchor.constraint(equalTo: self.cellImageView.trailingAnchor, constant: 32.0).isActive = true
            }
        }
    }
    
    let cellImageView : UIImageView = {
        let img = UIImageView()
        img.contentMode =  .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        //img.layer.cornerRadius = 35
        img.clipsToBounds = true
        img.tintColor = .black
        return img
    }()
    
    let cellLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    let separatorLineView : UIView = {
       let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.clipsToBounds = true
        line.backgroundColor = .groupTableViewBackground
        line.isHidden = true
        
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        containerView.addSubview(cellLabel)
        containerView.addSubview(cellImageView)
        containerView.addSubview(separatorLineView)
        self.contentView.addSubview(containerView)
        
        let cellHeight : CGFloat = 50.0
        let cellImgSize = CGPoint(x: 30.0, y: 30.0)
        
        let containerViewConstraints = [
            containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10.0),
            containerView.heightAnchor.constraint(equalToConstant: cellHeight) // #
        ]
        NSLayoutConstraint.activate(containerViewConstraints)
        
        let cellImageViewConstraints = [
            cellImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor), // #
            cellImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15.0),
            //cellImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0), // #
            //cellImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0),
            cellImageView.heightAnchor.constraint(equalToConstant: cellImgSize.y), // #
            cellImageView.widthAnchor.constraint(equalToConstant: cellImgSize.x) // #
        ]
        NSLayoutConstraint.activate(cellImageViewConstraints)
        
        let cellLabelConstraints = [
            cellLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            cellLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            cellLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            cellLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(cellLabelConstraints)
        
        let separatorLineViewConstraints = [
            separatorLineView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            separatorLineView.heightAnchor.constraint(equalToConstant: 2.0),
            separatorLineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            separatorLineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(separatorLineViewConstraints)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            SidebarTableViewCell.selectedTab?.setSelection(selected: false)
            self.setSelection(selected: true)
            SidebarTableViewCell.selectedTab = self
        } else {
            if self.tabIndex == HomeViewController.currentUserTabIndex {
                self.setSelection(selected: true)
                SidebarTableViewCell.selectedTab = self
            }
        }
    }
    
    func setSelection(selected: Bool) {
        if selected {
            self.contentView.backgroundColor = UIColor.black
            self.cellLabel.textColor = UIColor.systemYellow
            self.cellImageView.setImageColor(color: UIColor.systemYellow)
        } else {
            self.contentView.backgroundColor = nil
            if self.tab?.isSeparator == true {
                self.cellLabel.textColor = UIColor.darkGray
            } else {
                self.cellLabel.textColor = UIColor.black
            }
            self.cellImageView.setImageColor(color: UIColor.black)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
