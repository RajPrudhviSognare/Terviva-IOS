//
//  ReportsDetailsTableViewCell.swift
//  Smartrac-Grohe
//
//  Created by Happy on 19/06/22.
//

import UIKit

class ReportsDetailsTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var dateAppliedOnLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateAppliedOffLabel: UILabel!
    @IBOutlet weak var associatedIdLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    /*
     "attendance_date" = "2022-06-23";
     "attendance_date_sub" = "2022-06-23";
     "attendance_time" = "12:40 AM";
     "attendance_type" = in;
     "first_name" = Nitin;
     "isd_code" = 100390217;
     "last_name" = Khanna;
     "leave_type" = "";
     reason = "Commented...";
     status = pending;
     */
    //MARK:- Get Associates Reports Details Method
    func getAssociateReportsDetails(reports: [String: AnyObject]) {
        self.dateAppliedOnLabel.text = reports["attendance_date_sub"] as? String ?? ""
        self.nameLabel.text =
        "\(reports["first_name"] as? String ?? "") \(reports["last_name"] as? String ?? "")"
        self.typeLabel.text = reports["attendance_type"] as? String ?? ""
        self.timeLabel.text = reports["attendance_time"] as? String ?? ""
        self.dateAppliedOffLabel.text = reports["attendance_date"] as? String ?? ""
        self.associatedIdLabel.text = reports["isd_code"] as? String ?? ""
        self.reasonLabel.text = reports["reason"] as? String ?? ""
        self.statusLabel.text = reports["status"] as? String ?? ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
