//
//  MessageViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 18/06/22.
//

import UIKit

class MessageViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var messageTableview: UITableView!
    
    //MARK:- Variables
    var messagesArr = [AnyObject]()
    
    //MARK:- ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadXibNibFileMethod()
        self.getMessagesDeailsFromServerMethod()
    }
    
    //MARK:- Back Button Tapped
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK:- LoadXib Nib File Method
    func loadXibNibFileMethod()  {
        let detailsXibNib = UINib(nibName: TableViewViewCellIdentifiers.MessagesTableViewCell, bundle: nil)
        self.messageTableview.register(detailsXibNib, forCellReuseIdentifier: TableViewViewCellIdentifiers.MessagesTableViewCell)
    }
    
    //MARK:- Get Message Details Server Method
    func getMessagesDeailsFromServerMethod() {
        var messagesUrl = String()
        var params = [String: String]()
        SGCommonMethods.SharedInstance.showLoader()
        
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let role_id = userDefaults.object(forKey: "role_id") as? String ?? ""
        if role_id != "" {
            if role_id == "1" {
                messagesUrl = AppUrl.BaseUrl + MethodUrl.messagesUrl
                params = ["associate_id":id]
            } else {
                messagesUrl = AppUrl.BaseUrl + MethodUrl.getMessagesUrl
                params = ["tl_id":id]
            }
        }
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: messagesUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let data = responseDic["data"] as? [String: AnyObject] ?? [:]
            self.messagesArr = data["message_list"] as? [AnyObject] ?? []
            if status == true {
                DispatchQueue.main.async {
                    if self.messagesArr.count != 0 {
                    self.messageTableview.delegate = self
                    self.messageTableview.dataSource = self
                    self.messageTableview.reloadData()
                    } else {
                        self.messageTableview.setEmptyMessage(NOMessages)
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
extension MessageViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let messagesCell = self.messageTableview.dequeueReusableCell(withIdentifier: TableViewViewCellIdentifiers.MessagesTableViewCell, for: indexPath) as? MessagesTableViewCell else {
            return UITableViewCell()
        }
        let messagesObj = self.messagesArr[indexPath.row] as? [String:AnyObject] ?? [:]
        messagesCell.getMessagesDetails(messages: messagesObj)
        messagesCell.selectionStyle = .none
        return messagesCell
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
         "message_list" =         {
         };
     };
     message = "Message List!";
     status = 1;
 }
 
 
 {
     data =     {
         "message_list" =         {
         };
     };
     message = "Message List!";
     status = 1;
 }
 
 
 {
     "status": true,
     "message": "Message List!",
     "data": {
         "message_list": [
             {
                 "message": "hello",
                 "sub_time": "2022-06-24 10:04:58"
             }
         ]
     }
 }
 
 
 */
