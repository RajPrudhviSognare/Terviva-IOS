//
//  ReportsDetailsViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 19/06/22.
//

import UIKit

class ReportsDetailsViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var reportsDetailsTablview: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    //MARK:- Variables
    var month = String()
    var detailsReportArr = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.headerView.isHidden = true
        self.loadXibNibFileMethod()
        self.reportsDetailsTablview.tableHeaderView = self.headerView
        let userDefaults = UserDefaults.standard
        let role_id = userDefaults.object(forKey: "role_id") as? String ?? ""
        if role_id == "1" {
            self.getMonthlyDetailsReportsDeailsFromServerMethod(requiredMonth: self.month)
        } else {
            DispatchQueue.main.async {
                self.headerView.isHidden = false
                if self.detailsReportArr.count  != 0 {
                    self.reportsDetailsTablview.delegate = self
                    self.reportsDetailsTablview.dataSource = self
                    self.reportsDetailsTablview.reloadData()
                } else {
                    self.headerView.isHidden = true
                    self.reportsDetailsTablview.setEmptyMessage(NoRecords)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.deviceOrientation = .landscape
            UIDevice.current.setValue( UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.deviceOrientation = .portrait
            UIDevice.current.setValue( UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    //MARK:- Back Button Tapped
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- LoadXib Nib File Method
    func loadXibNibFileMethod()  {
        let detailsXibNib = UINib(nibName: TableViewViewCellIdentifiers.ReportsDetailsTableViewCell, bundle: nil)
        self.reportsDetailsTablview.register(detailsXibNib, forCellReuseIdentifier: TableViewViewCellIdentifiers.ReportsDetailsTableViewCell)
    }
    
    //MARK:- Get Monthly Reports Details Server Method
    func getMonthlyDetailsReportsDeailsFromServerMethod(requiredMonth: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let monthiyReportsUrl = AppUrl.BaseUrl + MethodUrl.monthlyDetailReportUrl
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let params = ["associate_id":id, "req_month": requiredMonth]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: monthiyReportsUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let data = responseDic["data"] as? [String: AnyObject] ?? [:]
            self.detailsReportArr = data["details"] as? [AnyObject] ?? []
            if status == true {
                DispatchQueue.main.async {
                    self.headerView.isHidden = false
                    if self.detailsReportArr.count  != 0 {
                        self.reportsDetailsTablview.delegate = self
                        self.reportsDetailsTablview.dataSource = self
                        self.reportsDetailsTablview.reloadData()
                    } else {
                        self.headerView.isHidden = true
                        self.reportsDetailsTablview.setEmptyMessage(NoRecords)
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
extension ReportsDetailsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailsReportArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reportsCell = self.reportsDetailsTablview.dequeueReusableCell(withIdentifier: TableViewViewCellIdentifiers.ReportsDetailsTableViewCell, for: indexPath) as? ReportsDetailsTableViewCell else {
            return UITableViewCell()
        }
        let reportDetailsObj = self.detailsReportArr[indexPath.row] as? [String:AnyObject] ?? [:]
        reportsCell.getAssociateReportsDetails(reports: reportDetailsObj)
        reportsCell.selectionStyle = .none
        return reportsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let bookingDetailsVC = StoryBoards.homeStoryBoard.instantiateViewController(withIdentifier: HomeControllers.bookingDetailsViewController) as? BookingDetailsViewController else {
//               return
//           }
//        let bookObj = self.currentBookArr[indexPath.row]
//        bookingDetailsVC.bookingObj = bookObj
//        self.parentNavigation.pushViewController(bookingDetailsVC, animated: true)
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
         details =         {
         };
     };
     message = "Attendance Report";
     status = 1;
 }
 
 
 {
     data =     {
         details =         (
                         {
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
             },
                         {
                 "attendance_date" = "2022-06-23";
                 "attendance_date_sub" = "2022-06-23";
                 "attendance_time" = "01:09 AM";
                 "attendance_type" = out;
                 "first_name" = Nitin;
                 "isd_code" = 100390217;
                 "last_name" = Khanna;
                 "leave_type" = "";
                 reason = "Commented...";
                 status = pending;
             },
                         {
                 "attendance_date" = "2022-06-23";
                 "attendance_date_sub" = "2022-06-23";
                 "attendance_time" = "01:13 AM";
                 "attendance_type" = leave;
                 "first_name" = Nitin;
                 "isd_code" = 100390217;
                 "last_name" = Khanna;
                 "leave_type" = Sick;
                 reason = "Commented...";
                 status = pending;
             }
         );
     };
     message = "Attendance Report";
     status = 1;
 }
 
 
 
 
 */
