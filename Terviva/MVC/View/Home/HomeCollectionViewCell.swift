//
//  HomeCollectionViewCell.swift
//  RGCA
//
//  Created by Apple on .
//  Copyright © 1942 Sciens. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.containerView.layer.cornerRadius = 10
//        self.containerView.layer.borderWidth = 2
//        self.containerView.layer.borderColor = SGColors.App_Theme?.cgColor
//        self.containerView.clipsToBounds = true
    }

}
