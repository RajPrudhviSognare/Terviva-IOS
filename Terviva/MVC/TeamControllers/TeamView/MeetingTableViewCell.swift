//
//  MeetingTableViewCell.swift
//  Smartrac-Grohe
//
//  Created by Happy on 26/06/22.
//

import UIKit

class MeetingTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var checkImageview: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
