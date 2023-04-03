//
//  MessagesTableViewCell.swift
//  Smartrac-Grohe
//
//  Created by Happy on 18/06/22.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK:- Get Messages Details Method
    func getMessagesDetails(messages: [String: AnyObject]) {
        self.messageLabel.text = messages["message"] as? String ?? ""
        self.dateLabel.text = messages["sub_time"] as? String ?? ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
