//
//  TeamMessagesTableViewCell.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit

class TeamMessagesTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var checkImageview: UIImageView!
    @IBOutlet weak var radioCheckImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func expand() {
        
    }
    
    func collapse() {
        
    }
}
