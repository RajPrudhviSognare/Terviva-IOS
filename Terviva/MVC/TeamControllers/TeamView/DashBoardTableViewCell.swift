//
//  DashBoardTableViewCell.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit

class DashBoardTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var timeStatusLabel: UILabel!
    @IBOutlet weak var approvedLabel: UILabel!
    @IBOutlet weak var rejectedLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var rejectLabel: UILabel!
    @IBOutlet weak var pendLabel: UILabel!
    @IBOutlet weak var approveLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getUserDetails(userObj: [String:AnyObject])  {
        self.timeStatusLabel.text = userObj[""] as? String ?? "0"
        self.approvedLabel.text = userObj[""] as? String ?? "0"
        self.rejectedLabel.text = userObj[""] as? String ?? "0"
        self.pendingLabel.text = userObj[""] as? String ?? "0"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
