//
//  AttendanceViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit

class AttendanceReportsViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var userSelectLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toolView: UIView!
    
    //MARK:- Variables
    var userSelected = String()
    var fromDateStr = String()
    var toDateStr = String()
    var formatter = DateFormatter()
    var userArr = [String]()
    var dateType = SelectDate.From
    var detailsReportArr = [AnyObject]()
    var associatesArr = [AssociateDetails]()
    var associatesObj = AssociateDetails()
    
    //MARK:- ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        formatter.dateFormat = "yyyy-MM-dd"
        self.toolView.isHidden = true
        self.fromDateLabel.text = formatter.string(from: datePicker.date)
        self.toDateLabel.text = formatter.string(from: datePicker.date)
        self.fromDateStr = formatter.string(from: datePicker.date)
        self.toDateStr = formatter.string(from: datePicker.date)
        self.datePicker.isHidden = true
        self.getAssociateReportsDeailsToServerMethod()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func userSelectedButtonTapped(_ sender: UIButton) {
        for associate in self.associatesArr {
            self.userArr.append("\(associate.firstName) \(associate.lastName)")
        }
        SGCommonMethods.SharedInstance.showPicker(title: "Select Associate", rows: [self.userArr], initialSelection: [0], completionPicking: { (reponseArr) in
            print(reponseArr)
            for associate in self.associatesArr {
                if reponseArr[0] == "\(associate.firstName) \(associate.lastName)" {
                    self.associatesObj.firstName = associate.firstName
                    self.associatesObj.lastName = associate.lastName
                    self.associatesObj.id = associate.id
                    self.associatesObj.isdCode = associate.isdCode
                    self.userSelectLabel.text = reponseArr[0]
                    self.userSelected = reponseArr[0]
                } else {
                    self.userSelectLabel.text = reponseArr[0]
                    self.userSelected = reponseArr[0]
                }
            }
        }, controller: self)
    }
    
    @IBAction func fromDateButtonTapped(_ sender: UIButton) {
        self.toolView.isHidden = false
        self.datePicker.isHidden = false
        self.dateType = SelectDate.From
    }
    
    @IBAction func toDateButtonTapped(_ sender: UIButton) {
        self.toolView.isHidden = false
        self.datePicker.isHidden = false
        self.dateType = SelectDate.To
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        switch self.dateType {
        case .From:
            self.fromDateLabel.text = formatter.string(from: datePicker.date)
            self.fromDateStr = formatter.string(from: datePicker.date)
        default:
            self.toDateLabel.text = formatter.string(from: datePicker.date)
            self.toDateStr = formatter.string(from: datePicker.date)
        }
        self.toolView.isHidden = true
        self.datePicker.isHidden = true
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.toolView.isHidden = true
        self.datePicker.isHidden = true
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if self.userSelected != "" && self.fromDateStr != "" && self.toDateStr != "" {
            self.sendAttendanceReportsDeailsToServerMethod(associateId: self.associatesObj.id, fromDate: self.fromDateStr, toDate: self.toDateStr)
        } else {
            self.showAlert(title: projectName, message: fillRequiredFields)
        }
    }
    
    //MARK:- Send InTime Deails ToServer Method
    func getAssociateReportsDeailsToServerMethod() {
        SGCommonMethods.SharedInstance.showLoader()
        let leaveUrl = AppUrl.BaseUrl + MethodUrl.teamReportAssociateListUrl
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let params = ["tl_id": id]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: leaveUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let data = responseDic["data"] as? [String: AnyObject] ?? [:]
            if status == true {
                DispatchQueue.main.async {
                    let associate = data["details"] as? [AnyObject] ?? []
                    for associateObj in associate {
                        let associateDetails = AssociateDetails(firstName: associateObj["first_name"] as? String ?? "", id: associateObj["id"] as? String ?? "", isdCode: associateObj["isd_code"] as? String ?? "", lastName: associateObj["last_name"] as? String ?? "")
                        self.associatesArr.append(associateDetails)
                    }
                    if self.associatesArr.count != 0 {
                    self.userSelectLabel.text = "\(self.associatesArr[0].firstName) \(self.associatesArr[0].lastName)"
                    self.userSelected = "\(self.associatesArr[0].firstName) \(self.associatesArr[0].lastName)"
                    }
                }
            } else {
                self.showAlert(title: projectName, message: LeaveUpError)
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
    }
    
    //MARK:- Send InTime Deails ToServer Method
    func sendAttendanceReportsDeailsToServerMethod(associateId: String, fromDate: String, toDate: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let inTimeUrl = AppUrl.BaseUrl + MethodUrl.teamGetDetialMonthReportUrl
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let params = ["associate_id": associateId,"tl_id": id,"start_date":fromDate ,"end_date": toDate]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: inTimeUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let data = responseDic["data"] as? [String: AnyObject] ?? [:]
            let details = data["details"] as? [AnyObject] ?? []
            if status == true {
                DispatchQueue.main.async {
                    guard let reportsDetailsVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.ReportsDetailsViewController) as? ReportsDetailsViewController else {
                        return
                    }
                    reportsDetailsVC.detailsReportArr = details
                    self.navigationController?.pushViewController(reportsDetailsVC, animated: true)
                }
            } else {
                self.showAlert(title: projectName, message: InTimeError)
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
        
    }
}

/*
 {
 data =     {
 details =         (
 {
 "first_name" = Manik;
 id = 316;
 "isd_code" = 100559296;
 "last_name" = Khana;
 }
 );
 };
 message = "Associates List";
 status = 1;
 
 
 {
 data =     {
 details = "<null>";
 };
 message = "Attendance Report";
 status = 1;
 }
 
 }
 */

struct AssociateDetails {
    var firstName = String()
    var id = String()
    var isdCode = String()
    var lastName = String()
}
