//
//  ReportsTableViewCell.swift
//  Smartrac-Grohe
//
//  Created by Happy on 19/06/22.
//

import UIKit

class ReportsTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var inLabel: UILabel!
    @IBOutlet weak var outLabel: UILabel!
    @IBOutlet weak var leaveLabel: UILabel!
    @IBOutlet weak var meetingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    //MARK:- Get Associates Reports Details Method
//    func getAssociateDetails(reports: [String: AnyObject]) {
//        self.monthLabel.text = reports[""] as? String ?? ""
//        self.inLabel.text = reports[""] as? String ?? ""
//        self.outLabel.text = reports[""] as? String ?? ""
//        self.weeklyLabel.text = reports[""] as? String ?? ""
//        self.leaveLabel.text = reports[""] as? String ?? ""
//        self.meetingLabel.text = reports[""] as? String ?? ""
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
