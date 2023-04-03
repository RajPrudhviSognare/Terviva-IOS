//
//  EditGroupTableViewCell.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit

class EditGroupTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
