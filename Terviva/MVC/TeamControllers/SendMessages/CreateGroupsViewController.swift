//
//  CreateGroupsViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit

class CreateGroupsViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var editTableView: UITableView!
    @IBOutlet weak var editCheckImageview: UIImageView!
    
    //MARK:- Variables
    var isShowEdit = Bool()
    var groupLists = [AnyObject]()
    var associatesArr = [AssociateDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadXibNibFileMethod()
        self.getGrpuoMessagesDeailsFromServerMethod()
    }
    
    //MARK:- LoadXib Nib File Method
    func loadXibNibFileMethod()  {
        let detailsXibNib = UINib(nibName: TableViewViewCellIdentifiers.EditGroupTableViewCell, bundle: nil)
        self.editTableView.register(detailsXibNib, forCellReuseIdentifier: TableViewViewCellIdentifiers.EditGroupTableViewCell)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func createGroupButtonTapped(_ sender: UIButton) {
        guard let createGroupVC = StoryBoards.teamStoryBoard.instantiateViewController(withIdentifier: TeamControllers.CreateNewGroupViewController) as? CreateNewGroupViewController else {
            return
        }
        createGroupVC.newGroup = CreateNewGroup.NewGroup
        self.navigationController?.pushViewController(createGroupVC, animated: true)
    }
    
    
    @IBAction func editDeleteButtonTapped(_ sender: UIButton) {
        if self.isShowEdit == false {
            self.isShowEdit = true
            self.editTableView.isHidden = false
            self.editCheckImageview.image = UIImage(named: "arrow_drop_up")
        } else {
            self.isShowEdit = false
            self.editTableView.isHidden = true
            self.editCheckImageview.image = UIImage(named: "drop_down_Black")
        }
//        self.editTableView.delegate = self
//        self.editTableView.dataSource = self
//        self.editTableView.reloadData()
    }
    
    //MARK:- Get Message Details Server Method
    func getGrpuoMessagesDeailsFromServerMethod() {
        SGCommonMethods.SharedInstance.showLoader()
        let messagesUrl = AppUrl.BaseUrl + MethodUrl.teamSendGroupMessagesUrl
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let params = ["tl_id":id]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: messagesUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let data = responseDic["data"] as? [String: AnyObject] ?? [:]
            let associate = data["associate"] as? [AnyObject] ?? []
            self.groupLists = data["group_lists"] as? [AnyObject] ?? []
            if status == true {
                DispatchQueue.main.async {
                    if self.groupLists.count != 0 {
                    self.editTableView.delegate = self
                    self.editTableView.dataSource = self
                    self.editTableView.reloadData()
                    } else {
                        self.editTableView.setEmptyMessage(NoRecords)
                    }
                }
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
    }
    
    //MARK:- Get Message Details Server Method
    func deleteAssociateMethod(index: Int, groupId: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let deleteAssociateUrl = AppUrl.BaseUrl + MethodUrl.teamDeleteAssociateUrl
        let params = ["group_id":groupId]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: deleteAssociateUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let message = responseDic["message"] as? String ?? ""
            if status == true {
                DispatchQueue.main.async {
                    self.showAlertWithTitle(withTitle: projectName, andMessage: message) { sucesss in
                        if sucesss == true {
                            self.groupLists.remove(at: index)
                            self.editTableView.reloadData()
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
extension CreateGroupsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupLists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let editGroupCell = self.editTableView.dequeueReusableCell(withIdentifier: TableViewViewCellIdentifiers.EditGroupTableViewCell, for: indexPath) as? EditGroupTableViewCell else {
            return UITableViewCell()
        }
        let groupList = self.groupLists[indexPath.row]
        let groupName = groupList["group_name"] as? String ?? ""
        editGroupCell.titleLabel.text = groupName
        editGroupCell.deleteButton.addTarget(self, action: #selector(deleteAssociateButton(sender:)), for: .touchUpInside)
        editGroupCell.deleteButton.isUserInteractionEnabled = true
        editGroupCell.deleteButton.tag = indexPath.row
        editGroupCell.deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        editGroupCell.editButton.addTarget(self, action: #selector(editAssociateButton(sender:)), for: .touchUpInside)
        editGroupCell.editButton.isUserInteractionEnabled = true
        editGroupCell.editButton.setImage(UIImage(named: "pencil"), for: .normal)
        editGroupCell.editButton.tag = indexPath.row
        editGroupCell.selectionStyle = .none
        return editGroupCell
    }
    
    @objc func deleteAssociateButton(sender: UIButton) {
        let groupList = self.groupLists[sender.tag]
        self.showAlertWithConformation(withTitle: groupList["group_name"] as? String ?? "", andMessage: deleteGrop) { success in
            if success == true {
                let groupList = self.groupLists[sender.tag]
                self.deleteAssociateMethod(index: sender.tag, groupId: groupList["group_id"] as? String ?? "")
            } else {
                
            }
        }
    }
    
    @objc func editAssociateButton(sender: UIButton) {
        let groupList = self.groupLists[sender.tag]
        let groupName = groupList["group_name"] as? String ?? ""
        guard let createGroupVC = StoryBoards.teamStoryBoard.instantiateViewController(withIdentifier: TeamControllers.CreateNewGroupViewController) as? CreateNewGroupViewController else {
            return
        }
        createGroupVC.groupName = groupName
        createGroupVC.newGroup = CreateNewGroup.UpdateGroup
        self.navigationController?.pushViewController(createGroupVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
 }

/*
 {
     data = "";
     message = "Group deleted successfully!";
     status = 1;
 }
 */
