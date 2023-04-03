//
//  CreateNewGroupViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit

class CreateNewGroupViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupTableview: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var checkImageview: UIImageView!
    
    //MARK:- Variables
    var associatesArr = [AssociateDetails]()
    var associatesObj = AssociateDetails()
    var newGroup = CreateNewGroup.NewGroup
    var groupName = String()
    var selectedAssociatedId = [String]()
    
    //MARK:- ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadXibNibFileMethod()
        self.groupTableview.tableHeaderView = self.headerView
        self.getAssociateReportsDeailsToServerMethod()
        self.checkImageview.image = UIImage(named: SGImages.radioUnCheckImage)
        switch self.newGroup {
        case .UpdateGroup:
            self.groupNameTextField.text = self.groupName
            self.titleLabel.text = "Update Group"
        default:
            self.titleLabel.text = "Create Group"
        }
    }
    
    //MARK:- LoadXib Nib File Method
    func loadXibNibFileMethod()  {
        let detailsXibNib = UINib(nibName: TableViewViewCellIdentifiers.NewGroupsTableViewCell, bundle: nil)
        self.groupTableview.register(detailsXibNib, forCellReuseIdentifier: TableViewViewCellIdentifiers.NewGroupsTableViewCell)
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectAllAssocoatesButtonTapped(_ sender: UIButton) {
        self.selectedAllAssociatesMethod()
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
                    self.groupTableview.delegate = self
                    self.groupTableview.dataSource = self
                    self.groupTableview.reloadData()
                }
            } else {
                self.showAlert(title: projectName, message: LeaveUpError)
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
    }
    
    //MARK:- Get Message Details Server Method
    func addGroupAssociateMethod(tlId: String, groupName: String, associateIds: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let deleteAssociateUrl = AppUrl.BaseUrl + MethodUrl.teamNewAddGroupUrl
        let params = ["tl_id":tlId, "group_name":groupName, "associate_ids": associateIds]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: deleteAssociateUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let message = responseDic["message"] as? String ?? ""
            if status == true {
                DispatchQueue.main.async {
                    self.showAlertWithTitle(withTitle: projectName, andMessage: message) { success in
                        if success == true {
                            self.navigationController?.popToViewController(ofClass: SendMessagesViewController.self, animated: true)
                        }
                    }
                }
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
    }
    
    //MARK:- Get Message Details Server Method
    func updateGroupAssociateMethod(groupId: String, groupName: String, associateIds: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let deleteAssociateUrl = AppUrl.BaseUrl + MethodUrl.teamUpdateAssociateUrl
        /*
         group_id :
         group_name:
         associate_ids:
         */
        let params = ["group_id":groupId, "group_name":groupName, "associate_ids": associateIds]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: deleteAssociateUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let message = responseDic["message"] as? String ?? ""
            if status == true {
                DispatchQueue.main.async {
                    self.showAlertWithTitle(withTitle: projectName, andMessage: message) { success in
                        if success == true {
                            self.navigationController?.popToViewController(ofClass: SendMessagesViewController.self, animated: true)
                        }
                    }
                }
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        let associateObj = self.associatesArr[sender.tag]
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let selectedAssociateJson = SGCommonMethods.SharedInstance.converArrayToJsonstring(from: self.selectedAssociatedId as Any)
        if self.groupNameTextField.text != "" {
            if self.selectedAssociatedId.count != 0 {
                switch self.newGroup {
                case .UpdateGroup:
                    self.updateGroupAssociateMethod(groupId: associateObj.id, groupName: self.groupNameTextField.text ?? "", associateIds: selectedAssociateJson ?? "")
                default:
                    self.addGroupAssociateMethod(tlId: id, groupName: self.groupNameTextField.text ?? "", associateIds: selectedAssociateJson ?? "")
                }
            } else {
                self.showAlert(title: projectName, message: KindlySelectAssociate)
            }
        } else {
            self.showAlert(title: projectName, message: PleaseSelectGroupName)
        }
    }
}

//MARK:- UITableView Delegate and DataSource Methods
extension CreateNewGroupViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.associatesArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newGroupCell = self.groupTableview.dequeueReusableCell(withIdentifier: TableViewViewCellIdentifiers.NewGroupsTableViewCell, for: indexPath) as? NewGroupsTableViewCell else {
            return UITableViewCell()
        }
        let associateObj = self.associatesArr[indexPath.row]
        newGroupCell.associateIdLabel.text = associateObj.isdCode
        newGroupCell.associateNameLabel.text = "\(associateObj.firstName)  \(associateObj.lastName)"
        newGroupCell.checkImageview.image = UIImage(named: SGImages.radioUnCheckImage)
        if self.checkImageview.image == UIImage(named: SGImages.radioCheckImage) {
            newGroupCell.checkImageview.image = UIImage(named: SGImages.radioCheckImage)
        }
        newGroupCell.selectionStyle = .none
        return newGroupCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newGroupCell = self.groupTableview.cellForRow(at: indexPath) as? NewGroupsTableViewCell {
            let associateObj = self.associatesArr[indexPath.row]
            if newGroupCell.checkImageview.image == UIImage(named: SGImages.radioUnCheckImage) {
                newGroupCell.checkImageview.image = UIImage(named: SGImages.radioCheckImage)
                self.selectedAssociatedId.append(associateObj.id)
            } else {
                newGroupCell.checkImageview.image = UIImage(named: SGImages.radioUnCheckImage)
                let removeObj = self.selectedAssociatedId.filter({$0 == associateObj.id})
                if removeObj.count != 0 {
                    self.selectedAssociatedId.remove(at: indexPath.row)
                }
            }
        }
    }
    
    func selectedAllAssociatesMethod() {
        for (index,element) in self.associatesArr.enumerated() {
//            let indexpathed = IndexPath(row: index, section: 0)
//            if let newGroupCell = self.groupTableview.cellForRow(at: indexpathed) as? NewGroupsTableViewCell {
                let associateObj = self.associatesArr[index]
                if self.checkImageview.image == UIImage(named: SGImages.radioUnCheckImage) {
                    self.checkImageview.image = UIImage(named: SGImages.radioCheckImage)
                    self.selectedAssociatedId.append(associateObj.id)
                } else {
                    self.checkImageview.image = UIImage(named: SGImages.radioUnCheckImage)
                    let removeObj = self.selectedAssociatedId.filter({$0 == associateObj.id})
                    if removeObj.count != 0 {
                        self.selectedAssociatedId.remove(at: index)
                    }
                }
            //}
        }
        self.groupTableview.reloadData()
    }
}
