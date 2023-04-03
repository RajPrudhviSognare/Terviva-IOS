//
//  DashBoardViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit

class DashBoardViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var dashBoardTableview: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userAmountLabel: UILabel!
    
    //MARK:- Variables
    var dataObj = [String: AnyObject]()
    var userObj = [String: AnyObject]()
    
    //MARK:- ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadXibNibFileMethod()
        self.dashBoardTableview.delegate = self
        self.dashBoardTableview.dataSource = self
        self.dashBoardTableview.tableHeaderView = self.headerView
        self.getUsersDeailsFromServerMethod()
    }
    
    //MARK:- LoadXib Nib File Method
    func loadXibNibFileMethod()  {
        let detailsXibNib = UINib(nibName: TableViewViewCellIdentifiers.DashBoardTableViewCell, bundle: nil)
        self.dashBoardTableview.register(detailsXibNib, forCellReuseIdentifier: TableViewViewCellIdentifiers.DashBoardTableViewCell)
    }
    
    //MARK:- Back Button Tapped
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Get Message Details Server Method
    func getUsersDeailsFromServerMethod() {
        SGCommonMethods.SharedInstance.showLoader()
        let messagesUrl = AppUrl.BaseUrl + MethodUrl.teamDashBoardAttendanceUrl
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let params = ["associate_id":id]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: messagesUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            self.dataObj = responseDic["data"] as? [String: AnyObject] ?? [:]
            self.userObj = self.dataObj["dashboard_count"] as? [String: AnyObject] ?? [:]
            if status == true {
                DispatchQueue.main.async {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMM d, yyyy"
                    let currentDate = formatter.string(from: Date())
                    self.dateLabel.text = currentDate
                    self.userAmountLabel.text = "\(self.dataObj["dashboard_associate_count"] as? Int ?? 0)"
                    if self.userObj.count != 0 {
                    self.dashBoardTableview.delegate = self
                    self.dashBoardTableview.dataSource = self
                    self.dashBoardTableview.reloadData()
                    } else {
                        self.dashBoardTableview.setEmptyMessage(NOMessages)
                    }
                }
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
    }
    
}

//MARK:- UITableView Delegate and DataSource Methods
extension DashBoardViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let usersCell = self.dashBoardTableview.dequeueReusableCell(withIdentifier: TableViewViewCellIdentifiers.DashBoardTableViewCell, for: indexPath) as? DashBoardTableViewCell else {
            return UITableViewCell()
        }
        usersCell.rejectLabel.isHidden = false
        usersCell.pendLabel.isHidden = false
        switch indexPath.row {
        case 0:
            usersCell.timeStatusLabel.text = "IN TIME"
            usersCell.approvedLabel.text = userObj["approve_in"] as? String ?? "0"
            usersCell.rejectedLabel.text = userObj["rejected_in"] as? String ?? "0"
            usersCell.pendingLabel.text = userObj["pending_in"] as? String ?? "0"
        case 1:
            usersCell.timeStatusLabel.text = "OUT TIME"
            usersCell.approvedLabel.text = userObj["approve_in"] as? String ?? "0"
            usersCell.rejectedLabel.text = userObj["rejected_in"] as? String ?? "0"
            usersCell.pendingLabel.text = userObj["pending_in"] as? String ?? "0"
        case 2:
            usersCell.timeStatusLabel.text = "Leave"
            usersCell.approvedLabel.text = userObj["approve_in"] as? String ?? "0"
            usersCell.rejectedLabel.text = userObj["rejected_in"] as? String ?? "0"
            usersCell.pendingLabel.text = userObj["pending_in"] as? String ?? "0"
        case 3:
            usersCell.timeStatusLabel.text = "ON DUTY"
            usersCell.approvedLabel.text = userObj["approve_in"] as? String ?? "0"
            usersCell.rejectedLabel.text = userObj["rejected_in"] as? String ?? "0"
            usersCell.pendingLabel.text = userObj["pending_in"] as? String ?? "0"
        case 4:
            usersCell.timeStatusLabel.text = "NOT AVAILABLE"
            usersCell.approvedLabel.text = self.dataObj["not_available"] as? String ?? "0"
            usersCell.rejectedLabel.text = ""
            usersCell.pendingLabel.text = ""
            usersCell.approveLabel.text = "Total"
            usersCell.rejectLabel.isHidden = true
            usersCell.pendLabel.isHidden = true
        default:
           break
        }
        usersCell.selectionStyle = .none
        return usersCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}


/*
 {
     data =     {
         "dashboard_associate_count" = 1;
         "dashboard_count" =         {
             absent = 0;
             "approve_in" = 0;
             "approve_leave" = 0;
             "approve_meeting" = 0;
             "approve_out" = 0;
             "approve_weekly_off" = 0;
             "pending_in" = 0;
             "pending_leave" = 0;
             "pending_meeting" = 0;
             "pending_out" = 0;
             "pending_weekly_off" = 0;
             "rejected_in" = 0;
             "rejected_leave" = 0;
             "rejected_meeting" = 0;
             "rejected_out" = 0;
             "rejected_weekly_off" = 0;
         };
         "not_available" = 1;
     };
     message = "Dashboard Report";
     status = 1;
 }
 */
