//
//  TeamViewViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit

class TeamViewViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var leaveTableview: UITableView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var checkImageview: UIImageView!
    
    //MARK:- Variables
    var leaveArr = [AnyObject]()
    var userArr = [String]()
    var pendingDate = [AnyObject]()
    var selectedDate = String()
    var isNavigate = NavigateToAttendance.Leave
    var selectedAssociatedId = [String]()
    
    //MARK:- ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.rejectButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        self.approveButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        self.loadXibNibFileMethod()
        self.selectedDateLabel.text = "Selected Date:"
        switch self.isNavigate {
        case .Leave:
            self.titleLabel.text = "Leave"
            self.geLeaveOnDutyDeailsFromServerMethod(type: "leave", monthDate: self.selectedDate)
        default:
            self.titleLabel.text = "Meeting"
            self.geLeaveOnDutyDeailsFromServerMethod(type: "meeting", monthDate: self.selectedDate)
        }
    }
    
    //MARK:- LoadXib Nib File Method
    func loadXibNibFileMethod()  {
        let detailsXibNib = UINib(nibName: TableViewViewCellIdentifiers.MeetingTableViewCell, bundle: nil)
        self.leaveTableview.register(detailsXibNib, forCellReuseIdentifier: TableViewViewCellIdentifiers.MeetingTableViewCell)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func dropDownButtonTapped(_ sender: UIButton) {
        var selectedArr = [String]()
        for selected in self.pendingDate {
            selectedArr.append(selected["attendance_date"] as? String ?? "")
        }
        if selectedArr.count != 0 {
            SGCommonMethods.SharedInstance.showPicker(title: "Selected Date", rows: [selectedArr], initialSelection: [0], completionPicking: { (reponseArr) in
                print(reponseArr)
                self.selectedDateLabel.text = "Selected Date: \(reponseArr[0])"
                self.selectedDate = reponseArr[0]
            }, controller: self)
        }
    }
    
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        self.selectedAllAssociatesMethod()
    }
    
    @IBAction func rejectButtonTapped(_ sender: UIButton) {
        if self.selectedAssociatedId.count != 0 {
            let rejectedAssociateJson = SGCommonMethods.SharedInstance.converArrayToJsonstring(from: self.selectedAssociatedId as Any)
            self.sendApproveRejectedDeailsToServerMethod(index:sender.tag,type: "rejected", attendanceIds: rejectedAssociateJson ?? "")
        } else {
            self.showAlert(title: projectName, message: KindlySelectAssociate)
        }
   }
    
    @IBAction func approveButtonTapped(_ sender: UIButton) {
        if self.selectedAssociatedId.count != 0 {
        let approvedAssociateJson = SGCommonMethods.SharedInstance.converArrayToJsonstring(from: self.selectedAssociatedId as Any)
            self.sendApproveRejectedDeailsToServerMethod(index:sender.tag,type: "approved", attendanceIds: approvedAssociateJson ?? "")
        } else {
            self.showAlert(title: projectName, message: KindlySelectAssociate)
        }
    }
    
    //MARK:- Get Message Details Server Method
    func geLeaveOnDutyDeailsFromServerMethod(type: String, monthDate: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let messagesUrl = AppUrl.BaseUrl + MethodUrl.teamGetAttendanceUrl
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let params = ["tl_id": id, "type": type,"m_date": monthDate]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: messagesUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let data = responseDic["data"] as? [String: AnyObject] ?? [:]
            self.leaveArr = data["attendance_data"] as? [AnyObject] ?? []
            self.pendingDate = data["pending_date"] as? [AnyObject] ?? []
            if status == true {
                DispatchQueue.main.async {
                    if self.leaveArr.count != 0 {
                        if self.selectedDate == "" {
                            let attendDate = self.pendingDate[0]["attendance_date"] as? String ?? ""
                            self.selectedDateLabel.text = "Selected Date: \(attendDate)"
                            self.selectedDate = attendDate
                        }
                        self.leaveTableview.delegate = self
                        self.leaveTableview.dataSource = self
                        self.leaveTableview.reloadData()
                    } else {
                        self.leaveTableview.setEmptyMessage(NoRecords)
                    }
                }
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
    }
    
    //MARK:- Send Approve and Reject Details Server Method
    func sendApproveRejectedDeailsToServerMethod(index:Int,type: String, attendanceIds: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let messagesUrl = AppUrl.BaseUrl + MethodUrl.teamAttendanceApprovedRejectUrl
        let attendanceIdParams = ["ids":self.selectedAssociatedId]
        let approvedAssociateJson = SGCommonMethods.SharedInstance.converArrayToJsonstring(from: attendanceIdParams)
        let params = ["action": type, "attendance_ids": approvedAssociateJson ?? "", "attendance_remarks": ""]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: messagesUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
           // let data = responseDic["data"] as? [String: AnyObject] ?? [:]
            if status == true {
                DispatchQueue.main.async {
                    switch self.isNavigate {
                    case .Leave:
                        switch type {
                        case "approved":
                            self.showAlertWithTitle(withTitle: Success, andMessage: LeaveApprovedAssociateSuccess) { success in
                                if success == true {
                                    if self.leaveArr.count != 0 {
                                       self.leaveArr.remove(at: index)
                                        if self.leaveArr.count == 0
                                        {
                                            self.leaveTableview.setEmptyMessage(NoRecords)
                                        }
                                     } else {
                                         self.leaveTableview.setEmptyMessage(NoRecords)
                                    }
                                    self.leaveTableview.reloadData()
                                }
                            }
                        default:
                            self.showAlertWithTitle(withTitle: Success, andMessage: LeaveRejectedAssociateSuccess) { success in
                                if success == true {
                                    if self.leaveArr.count != 0 {
                                       self.leaveArr.remove(at: index)
                                        if self.leaveArr.count == 0
                                        {
                                            self.leaveTableview.setEmptyMessage(NoRecords)
                                        }
                                     } else {
                                         self.leaveTableview.setEmptyMessage(NoRecords)
                                    }
                                    self.leaveTableview.reloadData()
                                }
                            }
                        }
                    default:
                        switch type {
                        case "approved":
                            self.showAlertWithTitle(withTitle: Success, andMessage: MeetingApprovedAssociateSuccess) { success in
                                if success == true {
                                    if self.leaveArr.count != 0 {
                                       self.leaveArr.remove(at: index)
                                        if self.leaveArr.count == 0
                                        {
                                            self.leaveTableview.setEmptyMessage(NoRecords)
                                        }
                                     } else {
                                         self.leaveTableview.setEmptyMessage(NoRecords)
                                    }
                                    self.leaveTableview.reloadData()
                                }
                            }
                        default:
                            self.showAlertWithTitle(withTitle: Success, andMessage: MeetingRejectedAssociateSuccess) { success in
                                if success == true {
                                    if self.leaveArr.count != 0 {
                                       self.leaveArr.remove(at: index)
                                        if self.leaveArr.count == 0
                                        {
                                            self.leaveTableview.setEmptyMessage(NoRecords)
                                        }
                                     } else {
                                         self.leaveTableview.setEmptyMessage(NoRecords)
                                    }
                                    self.leaveTableview.reloadData()
                                }
                            }
                        }
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
extension TeamViewViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leaveArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let leaveCell = self.leaveTableview.dequeueReusableCell(withIdentifier: TableViewViewCellIdentifiers.MeetingTableViewCell, for: indexPath) as? MeetingTableViewCell else {
            return UITableViewCell()
        }
        let leaveObj = self.leaveArr[indexPath.row] as? [String:AnyObject] ?? [:]
        leaveCell.nameLabel.text = "Name:    \(leaveObj["first_name"] as? String ?? "") \(leaveObj["last_name"] as? String ?? "")"
        leaveCell.idLabel.text = "ID:      \(leaveObj["associate_id"] as? String ?? "")"
        leaveCell.dateLabel.text = "Date:  \(leaveObj["attendance_date"] as? String ?? "")"
        leaveCell.reasonLabel.text = "Reason:  \(leaveObj["reason"] as? String ?? "")"
        leaveCell.selectionStyle = .none
        return leaveCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let leaveCell = self.leaveTableview.cellForRow(at: indexPath) as? MeetingTableViewCell {
            let attendanceObj = self.leaveArr[indexPath.row]
            if leaveCell.checkImageview.image == UIImage(named: SGImages.radioUnCheckImage) {
                leaveCell.checkImageview.image = UIImage(named: SGImages.radioCheckImage)
                self.selectedAssociatedId.append(attendanceObj["associate_id"] as? String ?? "")
            } else {
                leaveCell.checkImageview.image = UIImage(named: SGImages.radioUnCheckImage)
                let removeObj = self.selectedAssociatedId.filter({$0 == attendanceObj["associate_id"] as? String ?? ""})
                if removeObj.count != 0 {
                    self.selectedAssociatedId.remove(at: indexPath.row)
                }
            }
        }
    }
    
    func selectedAllAssociatesMethod() {
        for (index,element) in self.leaveArr.enumerated() {
            //            let indexpathed = IndexPath(row: index, section: 0)
            //            if let newGroupCell = self.groupTableview.cellForRow(at: indexpathed) as? NewGroupsTableViewCell {
            let attendanceObj = self.leaveArr[index]
            if self.checkImageview.image == UIImage(named: SGImages.radioUnCheckImage) {
                self.checkImageview.image = UIImage(named: SGImages.radioCheckImage)
                self.selectedAssociatedId.append(attendanceObj["associate_id"] as? String ?? "")
            } else {
                self.checkImageview.image = UIImage(named: SGImages.radioUnCheckImage)
                let removeObj = self.selectedAssociatedId.filter({$0 == attendanceObj["associate_id"] as? String ?? ""})
                if removeObj.count != 0 {
                    self.selectedAssociatedId.remove(at: index)
                }
            }
            //}
        }
        self.leaveTableview.reloadData()
    }
}


/*
 {
 data =     {
 "attendance_data" =         (
 );
 "particular_date" = "2022-06-27";
 "pending_date" =         (
 );
 };
 message = "Attendance Listing";
 status = 1;
 }
 */
