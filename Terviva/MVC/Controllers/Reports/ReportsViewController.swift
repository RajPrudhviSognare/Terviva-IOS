//
//  ReportsViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 18/06/22.
//

import UIKit

class ReportsViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var reportsTablview: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    //MARK:- Variables
    var current_month_result = [String: AnyObject]()
    var current_month =  String()
    var previous_month_result  = [String: AnyObject]()
    var previous_month = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.headerView.isHidden = true
        self.loadXibNibFileMethod()
        self.getMonthlyReportsDeailsFromServerMethod()
        self.reportsTablview.tableHeaderView = self.headerView
    }
    
    
    //MARK:- Back Button Tapped
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- LoadXib Nib File Method
    func loadXibNibFileMethod()  {
        let detailsXibNib = UINib(nibName: TableViewViewCellIdentifiers.ReportsTableViewCell, bundle: nil)
        self.reportsTablview.register(detailsXibNib, forCellReuseIdentifier: TableViewViewCellIdentifiers.ReportsTableViewCell)
    }
    
    //MARK:- Get Monthly Reports Details Server Method
    func getMonthlyReportsDeailsFromServerMethod() {
        SGCommonMethods.SharedInstance.showLoader()
        let monthiyReportsUrl = AppUrl.BaseUrl + MethodUrl.monthlyReportdUrl
        let userDefaults = UserDefaults.standard
        //let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "id") as? String ?? ""
        let params = ["associate_id":isd_code]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: monthiyReportsUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let data = responseDic["data"] as? [String: AnyObject] ?? [:]
            self.current_month_result = data["current_month_result"] as? [String: AnyObject] ?? [:]
            self.current_month = data["current_month"] as? String  ?? ""
            self.previous_month_result = data["previous_month_result"] as? [String: AnyObject] ?? [:]
            self.previous_month = data["previous_month"] as? String  ?? ""
            if status == true {
                DispatchQueue.main.async {
                    if data.count != 0 {
                        self.headerView.isHidden = false
                        self.reportsTablview.delegate = self
                        self.reportsTablview.dataSource = self
                        self.reportsTablview.reloadData()
                    } else {
                        self.headerView.isHidden = true
                        self.reportsTablview.setEmptyMessage(NoRecords)
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
extension ReportsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reportsCell = self.reportsTablview.dequeueReusableCell(withIdentifier: TableViewViewCellIdentifiers.ReportsTableViewCell, for: indexPath) as? ReportsTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            reportsCell.monthLabel.text = self.current_month
            reportsCell.inLabel.text =  self.current_month_result["in"] as? String ?? "0"
            reportsCell.outLabel.text =  self.current_month_result["out"] as? String ?? "0"
            
            reportsCell.leaveLabel.text =  self.current_month_result["leave"] as? String ?? "0"
            reportsCell.meetingLabel.text =  self.current_month_result["od"] as? String ?? "0"
        default:
            reportsCell.monthLabel.text = self.previous_month
            reportsCell.inLabel.text =  self.previous_month_result["in"] as? String ?? "0"
            reportsCell.outLabel.text =   self.previous_month_result["out"] as? String ?? "0"
            
            reportsCell.leaveLabel.text =   self.previous_month_result["leave"] as? String ?? "0"
            reportsCell.meetingLabel.text =   self.previous_month_result["od"] as? String ?? "0"
        }
        reportsCell.selectionStyle = .none
        return reportsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let reportsDetailsVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.ReportsDetailsViewController) as? ReportsDetailsViewController else {
            return
        }
        switch indexPath.row {
        case 0:
            reportsDetailsVC.month = self.current_month[0...3]
        default:
            reportsDetailsVC.month = self.previous_month[0...3]
        }
        self.navigationController?.pushViewController(reportsDetailsVC, animated: true)
    }
    
    //MARK: TableView Pagination
  /*  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.currentBookArr.count - 1 {
            if self.isDataLoadCompleted == false {
                let currentBookUrl = AppUrl.baseUrl + MethodsUrl.currentBookingUrl
                self.getCurrentBookingDetailsFromServerMethod(url: currentBookUrl, pageCount: self.pageCount, pageSize: self.pageSize)
                
            }
        }
    }*/
}

/*
 {
     data =     {
         "current_month" = "Jun-2022";
         "current_month_result" =         {
         };
         "previous_month" = "May-2022";
         "previous_month_result" =         {
         };
     };
     message = "Attendance Report";
     status = 1;
 }
 */
