//
//  LeaveBalanceTableViewCell.swift
//  Smartrac-Grohe
//
//  Created by Happy on 19/06/22.
//

import UIKit

class LeaveBalanceTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var leaveTitleLabel: UILabel!
    @IBOutlet weak var leaveValueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- Get Associates Reports Details Method
    func getLeaveDetails(leaveBalance: [String: AnyObject]) {
        self.leaveTitleLabel.text = leaveBalance[""] as? String ?? ""
        self.leaveValueLabel.text = leaveBalance[""] as? String ?? ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
