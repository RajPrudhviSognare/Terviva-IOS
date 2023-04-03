//
//  SendMessagesViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit

class SendMessagesViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var messagesTableview: UITableView!
    @IBOutlet weak var createMessageView: UIView!
    @IBOutlet weak var commentTextview: UITextView!
    @IBOutlet weak var floatButton: UIButton!
    
    //MARK:- Variables
    var groupLists = [AnyObject]()
    var associatesArr = [AssociateDetails]()
    var associatesLists = [AnyObject]()
    var selectedIndexPath: IndexPath?
    var extraHeight: CGFloat = 100
    var headerView = TeamMessageView()
    var isSelected = -1
    var isSelectedArr = [Int]()
    var selectedAssociatedId = [String]()
    var isSelectAll = -1
    var isSelectRow = -1
    var selectedIndexPathArr = [IndexPath]()
    
    //MARK:- ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadXibNibFileMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getGrpuoMessagesDeailsFromServerMethod()
    }
    
    //MARK:- LoadXib Nib File Method
    func loadXibNibFileMethod()  {
        let nib = UINib(nibName: TableViewViewCellIdentifiers.TeamMessageView, bundle: nil)
        self.messagesTableview.register(nib, forHeaderFooterViewReuseIdentifier: TableViewViewCellIdentifiers.TeamMessageView)
        let detailsXibNib = UINib(nibName: TableViewViewCellIdentifiers.TeamMessagesTableViewCell, bundle: nil)
        self.messagesTableview.register(detailsXibNib, forCellReuseIdentifier: TableViewViewCellIdentifiers.TeamMessagesTableViewCell)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
                        self.messagesTableview.delegate = self
                        self.messagesTableview.dataSource = self
                        self.messagesTableview.reloadData()
                    } else {
                        self.messagesTableview.setEmptyMessage(NoRecords)
                    }
                }
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
    }
    
    //MARK:- Get Message Details Server Method
    func sendMessagesDeailsToerverMethod(message: String, associateIDS: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let messagesUrl = AppUrl.BaseUrl + MethodUrl.teamSendMessagesUrl
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let params = ["tl_id": id, "associate_ids": associateIDS,"message": message]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: messagesUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let message = responseDic["message"] as? String ?? ""
            if status == true {
                DispatchQueue.main.async {
                    self.showAlertWithTitle(withTitle: projectName, andMessage: message) { success in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
    }
    
    @IBAction func createGroupButtonTappped(_ sender: UIButton) {
        guard let createGroupVC = StoryBoards.teamStoryBoard.instantiateViewController(withIdentifier: TeamControllers.CreateGroupsViewController) as? CreateGroupsViewController else {
            return
        }
        
        self.navigationController?.pushViewController(createGroupVC, animated: true)
    }
    
    
    @IBAction func createNewMessageButtonTapped(_ sender: UIButton) {
        if self.selectedAssociatedId.count != 0 {
            self.createMessageView.isHidden = false
        } else {
            self.showAlert(title: projectName, message: KindlySelectAssociate)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.createMessageView.isHidden = true
    }
    
    @IBAction func closeButtontapped(_ sender: UIButton) {
        self.createMessageView.isHidden = true
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        let selectedAssociateJson = SGCommonMethods.SharedInstance.converArrayToJsonstring(from: self.selectedAssociatedId as Any)
        if self.commentTextview.text != "" {
            self.sendMessagesDeailsToerverMethod(message: "Commented...", associateIDS: selectedAssociateJson ?? "")
        } else {
            self.showAlert(title: projectName, message: fillRequiredFields)
        }
    }
    
}

//MARK:- UITableView Delegate and DataSource Methods
extension SendMessagesViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupLists.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let groupList = self.groupLists[section]
        let associateList = groupList["associate_lists"] as? [AnyObject] ?? []
        return associateList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let selectedFilter = self.isSelectedArr.filter({$0 == indexPath.section})
//        if self.isSelected == indexPath.section {
        if selectedFilter.count != 0 {
            return 60
        } else {
            return  0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = self.messagesTableview.dequeueReusableHeaderFooterView(withIdentifier: TableViewViewCellIdentifiers.TeamMessageView)  as? TeamMessageView else {
            return UIView()
        }
        let groupList = self.groupLists[section]
        headerView.nameLabel.text = groupList["group_name"] as? String ?? ""
        headerView.checkButton.addTarget(self, action: #selector(checkButtonTapped(sender:)), for: .touchUpInside)
        headerView.checkButton.tag = section
        if self.isSelected == section {
            headerView.checkImageview.image = UIImage(named:"arrow_drop_up")
        }else {
            headerView.checkImageview.image = UIImage(named:"drop_down_Black")
        }
        if self.isSelectAll == section {
            headerView.radioImageview.image = UIImage(named: "icon_checked")
        } else {
            headerView.radioImageview.image = UIImage(named: "icon_unchecked")
        }
        headerView.radioButton.addTarget(self, action: #selector(selectAssociatesButtonTapped(sender:)), for: .touchUpInside)
        headerView.radioButton.tag = section
        return headerView
    }
    
    @objc func checkButtonTapped(sender: UIButton)  {
        if self.isSelected == sender.tag {
            self.isSelected = -1
            if self.isSelectedArr.contains(sender.tag) {
                self.isSelectedArr.remove(element: sender.tag)
            }
        } else {
            self.isSelected = sender.tag
            if !self.isSelectedArr.contains(sender.tag) {
                self.isSelectedArr.append(sender.tag)
            }
        }
        self.messagesTableview.reloadSections([sender.tag], with: .fade)
    }
    
    @objc func selectAssociatesButtonTapped(sender: UIButton)  {
        let groupList = self.groupLists[sender.tag]
        let associateList = groupList["associate_lists"] as? [AnyObject] ?? []
        let indexPathed = IndexPath(row: 0, section: sender.tag)
        self.isSelectAll = sender.tag
        self.messagesTableview.reloadSections([sender.tag], with: .fade)
        if let messagesCell = self.messagesTableview.cellForRow(at: indexPathed) as? TeamMessagesTableViewCell {
            for associate in associateList {
                self.selectedAssociatedId.append(associate["associate_id"] as? String ?? "")
                messagesCell.checkImageview.image = UIImage(named: "icon_checked")
                messagesCell.radioCheckImageview.image = UIImage(named: "icon_checked")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupList = self.groupLists[indexPath.section]
        let associateList = groupList["associate_lists"] as? [AnyObject] ?? []
        let associateObj = associateList[indexPath.row] as? [String: AnyObject] ?? [:]
        guard let messagesCell = self.messagesTableview.dequeueReusableCell(withIdentifier: TableViewViewCellIdentifiers.TeamMessagesTableViewCell, for: indexPath) as? TeamMessagesTableViewCell else {
            return UITableViewCell()
        }
        let firstName = associateObj["first_name"] as? String ?? ""
        let lastName = associateObj["last_name"] as? String ?? ""
        messagesCell.nameLabel.text = "\(firstName) \(lastName)"
        messagesCell.radioButton.addTarget(self, action: #selector(selectAssociatesCheckButtonTapped(sender:)), for: .touchUpInside)
        messagesCell.radioButton.tag = (indexPath.section*100)+indexPath.row
        messagesCell.checkButton.addTarget(self, action: #selector(selectAssociatesCheckButtonTapped(sender:)), for: .touchUpInside)
        messagesCell.checkButton.tag = (indexPath.section*100)+indexPath.row
        if selectedIndexPath == indexPath  {
            messagesCell.checkImageview.image = UIImage(named: "icon_checked")
            messagesCell.radioCheckImageview.image = UIImage(named: "icon_checked")
        } else {
            messagesCell.checkImageview.image = UIImage(named: "icon_unchecked")
            messagesCell.radioCheckImageview.image = UIImage(named: "icon_unchecked")
        }
        messagesCell.selectionStyle = .none
        return messagesCell
    }
    
    @objc func selectAssociatesCheckButtonTapped(sender: UIButton)  {
        let indexPathed = IndexPath(row: sender.tag % 100, section: sender.tag / 100)
        let groupList = self.groupLists[sender.tag / 100]
        let associateList = groupList["associate_lists"] as? [AnyObject] ?? []
        let associateObj = associateList[indexPathed.row] as? [String: AnyObject] ?? [:]
    
        if (self.selectedIndexPathArr.contains(indexPathed)) {
            self.selectedIndexPathArr.remove(element: indexPathed)
            self.selectedIndexPath = nil
            if self.selectedAssociatedId.contains(associateObj["associate_id"] as? String ?? "") {
                self.selectedAssociatedId.remove(element: associateObj["associate_id"] as? String ?? "")
            }
        } else {
           if self.selectedIndexPath == indexPathed {
                self.selectedIndexPath = nil
               if (self.selectedIndexPathArr.contains(indexPathed)) {
                   self.selectedIndexPathArr.remove(element: indexPathed)
               }
                if self.selectedAssociatedId.contains(associateObj["associate_id"] as? String ?? "") {
                    self.selectedAssociatedId.remove(element: associateObj["associate_id"] as? String ?? "")
                }
            } else {
                self.selectedIndexPath = indexPathed
                if !(self.selectedIndexPathArr.contains(indexPathed)) {
                   self.selectedIndexPathArr.append(indexPathed)
                }
                if !self.selectedAssociatedId.contains(associateObj["associate_id"] as? String ?? "") {
                    self.selectedAssociatedId.append(associateObj["associate_id"] as? String ?? "")
                }
        }
    }
        self.messagesTableview.reloadRows(at: [indexPathed], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

extension Array where Element: Equatable{
    mutating func remove (element: Element) {
        if let i = self.firstIndex(of: element) {
            self.remove(at: i)
        }
    }
}

/*
 
 {
     data = "";
     message = "Message Set successfully!";
     status = 1;
 }
 
 {
 data =     {
 associate =         (
 {
 "first_name" = Manik;
 id = 316;
 "isd_code" = 100559296;
 "last_name" = Khana;
 }
 );
 "group_lists" =         (
 {
 "associate_lists" =                 (
 {
 "associate_id" = 316;
 "first_name" = Manik;
 "isd_code" = 100559296;
 "last_name" = Khana;
 }
 );
 "group_id" = 5;
 "group_name" = fghy;
 },
 {
 "associate_lists" =                 (
 {
 "associate_id" = 316;
 "first_name" = Manik;
 "isd_code" = 100559296;
 "last_name" = Khana;
 }
 );
 "group_id" = 6;
 "group_name" = raghava;
 }
 );
 };
 message = "Group List!";
 status = 1;
 }
 
 
 
 {
     data =     {
         associate =         (
                         {
                 "first_name" = Manik;
                 id = 316;
                 "isd_code" = 100559296;
                 "last_name" = Khana;
             }
         );
         "group_lists" =         (
                         {
                 "associate_lists" =                 (
                                         {
                         "associate_id" = 316;
                         "first_name" = Manik;
                         "isd_code" = 100559296;
                         "last_name" = Khana;
                     }
                 );
                 "group_id" = 15;
                 "group_name" = Amma;
             },
                         {
                 "associate_lists" =                 (
                                         {
                         "associate_id" = 316;
                         "first_name" = Manik;
                         "isd_code" = 100559296;
                         "last_name" = Khana;
                     }
                 );
                 "group_id" = 8;
                 "group_name" = "Happy ";
             },
                         {
                 "associate_lists" =                 (
                                         {
                         "associate_id" = 316;
                         "first_name" = Manik;
                         "isd_code" = 100559296;
                         "last_name" = Khana;
                     }
                 );
                 "group_id" = 11;
                 "group_name" = "Happy Bujji";
             },
                         {
                 "associate_lists" =                 (
                                         {
                         "associate_id" = 316;
                         "first_name" = Manik;
                         "isd_code" = 100559296;
                         "last_name" = Khana;
                     }
                 );
                 "group_id" = 9;
                 "group_name" = "kushi ";
             },
                         {
                 "associate_lists" =                 (
                                         {
                         "associate_id" = 316;
                         "first_name" = Manik;
                         "isd_code" = 100559296;
                         "last_name" = Khana;
                     }
                 );
                 "group_id" = 13;
                 "group_name" = Mani;
             },
                         {
                 "associate_lists" =                 (
                                         {
                         "associate_id" = 316;
                         "first_name" = Manik;
                         "isd_code" = 100559296;
                         "last_name" = Khana;
                     }
                 );
                 "group_id" = 12;
                 "group_name" = "raghava Happy";
             },
                         {
                 "associate_lists" =                 (
                                         {
                         "associate_id" = 316;
                         "first_name" = Manik;
                         "isd_code" = 100559296;
                         "last_name" = Khana;
                     }
                 );
                 "group_id" = 17;
                 "group_name" = Raghavendra;
             },
                         {
                 "associate_lists" =                 (
                                         {
                         "associate_id" = 316;
                         "first_name" = Manik;
                         "isd_code" = 100559296;
                         "last_name" = Khana;
                     }
                 );
                 "group_id" = 18;
                 "group_name" = "Raghavendra Royal";
             }
         );
     };
     message = "Group List!";
     status = 1;
 }
 
 
 */
