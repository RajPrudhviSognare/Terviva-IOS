//
//  NewGroupsTableViewCell.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit

class NewGroupsTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var associateIdLabel: UILabel!
    @IBOutlet weak var associateNameLabel: UILabel!
    @IBOutlet weak var checkImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
