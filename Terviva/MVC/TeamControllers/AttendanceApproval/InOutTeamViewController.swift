//
//  InOutTeamViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit
import SDWebImage

protocol InOutDelegate {
    func getCommentsDetails(comments: String)
}

class InOutTeamViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var inOutTableview: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var checkImageview: UIImageView!
    
    //MARK:- Variables
    var attendanceArr = [AnyObject]()
    var pendingDate = [AnyObject]()
    var selectedDate = String()
    var selectedAssociatedId = [String]()
    var commentArr = [String]()
    var commentsStr = String()
    
    //MARK:- ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.loadXibNibFileMethod()
        self.inOutTableview.tableHeaderView = self.headerView
        self.checkImageview.image = UIImage(named: SGImages.radioUnCheckImage)
        self.getInOutDeailsFromServerMethod(type: "in", monthDate: self.selectedDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.deviceOrientation = .landscape
            UIDevice.current.setValue( UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    //MARK:- LoadXib Nib File Method
    func loadXibNibFileMethod()  {
        let detailsXibNib = UINib(nibName: TableViewViewCellIdentifiers.InOutTeamTableViewCell, bundle: nil)
        self.inOutTableview.register(detailsXibNib, forCellReuseIdentifier: TableViewViewCellIdentifiers.InOutTeamTableViewCell)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.deviceOrientation = .portrait
            UIDevice.current.setValue( UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    @IBAction func selectedDateButtonTapped(_ sender: UIButton) {
        var selectedArr = [String]()
        for selected in self.pendingDate {
            selectedArr.append(selected["attendance_date"] as? String ?? "")
        }
        if selectedArr.count != 0 {
            SGCommonMethods.SharedInstance.showPicker(title: "Selected Date", rows: [selectedArr], initialSelection: [0], completionPicking: { (reponseArr) in
                print(reponseArr)
                self.selectedDateLabel.text = reponseArr[0]
                self.selectedDate = reponseArr[0]
                self.getInOutDeailsFromServerMethod(type: "in", monthDate: self.selectedDate)
            }, controller: self)
        }
    }
    
    @IBAction func selectAllButtonTapped(_ sender: UIButton) {
        selectedAllAssociatesMethod()
    }
    
    //MARK:- Get Message Details Server Method
    func getInOutDeailsFromServerMethod(type: String, monthDate: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let messagesUrl = AppUrl.BaseUrl + MethodUrl.teamGetAttendanceUrl
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        /*
         m_date :
         type : "in"  or  "meeting" (Duty)  or "leave"
         tl_id :
         */
        let params = ["tl_id": id, "type": type,"m_date": monthDate]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: messagesUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let data = responseDic["data"] as? [String: AnyObject] ?? [:]
            self.attendanceArr = data["attendance_data"] as? [AnyObject] ?? []
            self.pendingDate = data["pending_date"] as? [AnyObject] ?? []
            if status == true {
                DispatchQueue.main.async {
                    if self.attendanceArr.count != 0 {
                        if self.selectedDate == "" {
                            let attendDate = self.pendingDate[0]["attendance_date"] as? String ?? ""
                            self.selectedDateLabel.text = attendDate
                            self.selectedDate = attendDate
                        }
                        self.inOutTableview.delegate = self
                        self.inOutTableview.dataSource = self
                        self.inOutTableview.reloadData()
                    } else {
                        self.inOutTableview.setEmptyMessage(NoRecords)
                    }
                }
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
    }
    
    @IBAction func rejectButtonTapped(_ sender: UIButton) {
        if self.selectedAssociatedId.count != 0 {
            if self.commentsStr != "" {
            self.sendApproveRejectedDeailsToServerMethod(index:sender.tag,type: "rejected")
            } else {
                self.showAlert(title: projectName, message: PleaseEnterYourComments)
            }
        } else {
            self.showAlert(title: projectName, message: KindlySelectAssociate)
        }
    }
    
    @IBAction func approveButtonTapped(_ sender: UIButton) {
        if self.selectedAssociatedId.count != 0  {
            if self.commentsStr != "" {
                self.sendApproveRejectedDeailsToServerMethod(index:sender.tag, type: "approved")
            } else {
                self.showAlert(title: projectName, message: PleaseEnterYourComments)
            }
        } else {
            self.showAlert(title: projectName, message: KindlySelectAssociate)
        }
    }
    
    //MARK:- Send Approve and Reject Details Server Method
    func sendApproveRejectedDeailsToServerMethod(index:Int, type: String) {
        SGCommonMethods.SharedInstance.showLoader()
        self.commentArr.append(self.commentsStr)
        let messagesUrl = AppUrl.BaseUrl + MethodUrl.teamAttendanceApprovedRejectUrl
        let attendanceIdParams = ["ids":self.selectedAssociatedId]
        let remarksParams = ["remarks":self.commentArr]
        let remarksJson = SGCommonMethods.SharedInstance.converArrayToJsonstring(from: remarksParams as Any)
        let approvedAssociateJson = SGCommonMethods.SharedInstance.converArrayToJsonstring(from: attendanceIdParams)
        let params = ["action": type, "attendance_ids": approvedAssociateJson ?? "", "attendance_remarks": remarksJson ?? ""] as [String : Any]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: messagesUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let data = responseDic["data"] as? [String: AnyObject] ?? [:]
            if status == true {
                DispatchQueue.main.async {
                    switch type {
                    case "approved":
                        self.showAlertWithTitle(withTitle: Success, andMessage: InOutApprovedAssociateSuccess) { success in
                            if success == true {
                                if self.attendanceArr.count != 0 {
                                   self.attendanceArr.remove(at: index)
                                    if self.attendanceArr.count == 0
                                    {
                                        self.inOutTableview.setEmptyMessage(NoRecords)
                                    }
                                 } else {
                                    self.inOutTableview.setEmptyMessage(NoRecords)
                                }
                                self.inOutTableview.reloadData()
                            }
                        }
                    default:
                        self.showAlertWithTitle(withTitle: Success, andMessage: InOutRejectedAssociateSuccess) { success in
                            if success == true {
                                if self.attendanceArr.count != 0 {
                                   self.attendanceArr.remove(at: index)
                                    if self.attendanceArr.count == 0
                                    {
                                        self.inOutTableview.setEmptyMessage(NoRecords)
                                    }
                                 } else {
                                    self.inOutTableview.setEmptyMessage(NoRecords)
                                }
                                self.inOutTableview.reloadData()
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

extension InOutTeamViewController: InOutDelegate {
    
    func getCommentsDetails(comments: String) {
        print(comments)
        self.commentsStr = comments
    }
}

//MARK:- UITableView Delegate and DataSource Methods
extension InOutTeamViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.attendanceArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let inOutCell = self.inOutTableview.dequeueReusableCell(withIdentifier: TableViewViewCellIdentifiers.InOutTeamTableViewCell, for: indexPath) as? InOutTeamTableViewCell else {
            return UITableViewCell()
        }
        let attendanceObj = self.attendanceArr[indexPath.row] as? [String: AnyObject] ?? [:]
        inOutCell.nameLabel.text = "\(attendanceObj["first_name"] as? String ?? "") \(attendanceObj["last_name"] as? String ?? "") \n(\(attendanceObj["isd_code"] as? String ?? ""))"
        inOutCell.typeTimeLabel.text = "\(attendanceObj["attendance_type"] as? String ?? "") \(attendanceObj["attendance_time"] as? String ?? "")"
        inOutCell.commentsLabel.text = attendanceObj["reason"] as? String ?? ""
        inOutCell.variationLabel.text = attendanceObj["distance"] as? String ?? ""
        let imgUrl = attendanceObj["attendance_image"] as? String ?? ""
        let imageUrl = AppUrl.imageBaseUrl + imgUrl
        inOutCell.profileImageview.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "usericon1"))
        inOutCell.checkImageview.image = UIImage(named: SGImages.radioUnCheckImage)
        if self.checkImageview.image == UIImage(named: SGImages.radioCheckImage) {
            inOutCell.checkImageview.image = UIImage(named: SGImages.radioCheckImage)
        }
        inOutCell.commentsDelegate = self
        inOutCell.selectionStyle = .none
        return inOutCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let inOutCell = self.inOutTableview.cellForRow(at: indexPath) as? InOutTeamTableViewCell {
            let attendanceObj = self.attendanceArr[indexPath.row]
            if inOutCell.checkImageview.image == UIImage(named: SGImages.radioUnCheckImage) {
                inOutCell.checkImageview.image = UIImage(named: SGImages.radioCheckImage)
                self.selectedAssociatedId.append(attendanceObj["id"] as? String ?? "")
            } else {
                inOutCell.checkImageview.image = UIImage(named: SGImages.radioUnCheckImage)
                let removeObj = self.selectedAssociatedId.filter({$0 == attendanceObj["id"] as? String ?? ""})
                if removeObj.count != 0 {
                    self.selectedAssociatedId.remove(at: indexPath.row)
                }
            }
        }
        
    }
    
    func selectedAllAssociatesMethod() {
        for (index,element) in self.attendanceArr.enumerated() {
            //            let indexpathed = IndexPath(row: index, section: 0)
            //            if let newGroupCell = self.groupTableview.cellForRow(at: indexpathed) as? NewGroupsTableViewCell {
            let attendanceObj = self.attendanceArr[index]
            if self.checkImageview.image == UIImage(named: SGImages.radioUnCheckImage) {
                self.checkImageview.image = UIImage(named: SGImages.radioCheckImage)
                self.selectedAssociatedId.append(attendanceObj["id"] as? String ?? "")
            } else {
                self.checkImageview.image = UIImage(named: SGImages.radioUnCheckImage)
                let removeObj = self.selectedAssociatedId.filter({$0 == attendanceObj["id"] as? String ?? ""})
                if removeObj.count != 0 {
                    self.selectedAssociatedId.remove(at: index)
                }
            }
            //}
        }
        self.inOutTableview.reloadData()
    }
}

/*
 {
 data =     {
 "attendance_data" =         (
 {
 "associate_id" = 316;
 "attendance_date" = "2022-06-27";
 "attendance_image" = "62b93ce1d86b0.jpg";
 "attendance_time" = "10:45 AM";
 "attendance_type" = in;
 distance = "0.00";
 "first_name" = Manik;
 id = 3199;
 "isd_code" = 100559296;
 "last_name" = Khana;
 latitude = "32.6792005";
 "leave_type" = "";
 longitude = "74.8876315";
 "outlet_code" = "<null>";
 "outlet_id" = 0;
 "outlet_name" = "<null>";
 reason = "";
 remarks = "";
 "tl_id" = 229;
 }
 );
 "particular_date" = "2022-06-27";
 "pending_date" =         (
 {
 "attendance_date" = "2022-06-27";
 selected = 1;
 },
 {
 "attendance_date" = "2022-06-23";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-22";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-21";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-20";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-18";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-17";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-16";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-15";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-13";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-11";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-10";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-09";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-08";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-07";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-06";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-04";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-03";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-02";
 selected = 0;
 },
 {
 "attendance_date" = "2022-06-01";
 selected = 0;
 }
 );
 };
 message = "Attendance Listing";
 status = 1;
 }
 */
