//
//  FormatsViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 18/06/22.
//

import UIKit

class FormatsViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var formatsTablview: UITableView!
    
    //MARK:- Variables
    var parentNavigation = UINavigationController()
    var formatsArr = [AnyObject]()
    
    //MARK:- ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadXibNibFileMethod()
        self.formatsTablview.delegate = self
        self.formatsTablview.dataSource = self
        self.getFormatsDetailsFromServerMethod(url: AppUrl.BaseUrl + MethodUrl.formatsUrl)
    }
    
    //MARK:- LoadXib Nib File Method
    func loadXibNibFileMethod()  {
        let detailsXibNib = UINib(nibName: TableViewViewCellIdentifiers.FormatsTableViewCell, bundle: nil)
        self.formatsTablview.register(detailsXibNib, forCellReuseIdentifier: TableViewViewCellIdentifiers.FormatsTableViewCell)
    }
    
    //MARK:- Get Formats Details Method
    func getFormatsDetailsFromServerMethod(url: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let userDefaults = UserDefaults.standard
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: [:], imageDataDic: [:], baseUrl: url) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let data = responseDic["data"] as? [String: AnyObject] ?? [:]
            self.formatsArr = data["documents"] as? [AnyObject] ?? []
            if status == true {
                DispatchQueue.main.async {
                    if self.formatsArr.count != 0 {
                        self.formatsTablview.delegate = self
                        self.formatsTablview.dataSource = self
                        self.formatsTablview.reloadData()
                    } else {
                        self.formatsTablview.setEmptyMessage(NoDocuments)
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
extension FormatsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formatsArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let formatsCell = self.formatsTablview.dequeueReusableCell(withIdentifier: TableViewViewCellIdentifiers.FormatsTableViewCell, for: indexPath) as? FormatsTableViewCell else {
            return UITableViewCell()
        }
        let formatsObj = self.formatsArr[indexPath.row] as? [String: AnyObject] ?? [:]
        formatsCell.titleLabel.text = formatsObj["title"] as? String ?? ""
        formatsCell.downloadButton.addTarget(self, action: #selector(self.dowmloadButtonTapped(sender:)), for: .touchUpInside)
        formatsCell.downloadButton.tag = indexPath.row
        formatsCell.downloadButton.isUserInteractionEnabled = true
        formatsCell.selectionStyle = .none
        return formatsCell
    }
    
    @objc func dowmloadButtonTapped(sender: UIButton) {
        let index = sender.tag
        let formatsObj = self.formatsArr[index] as? [String: AnyObject] ?? [:]
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            guard let url = URL(string: formatsObj["file_url"] as? String ?? "") else {
              return //be safe
            }

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
         }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

/*
 {
     data =     {
         documents =         (
                         {
                 "doc_file_ext" = ".xlsx";
                 "doc_type" = formats;
                 "file_name" = c81e728d9d4c2f636f067f89cc14862c;
                 "file_url" = "http://grohe.smartrac.manpoweronline.in/uploads/documents/local_format.xlsx";
                 title = "Local Format";
             },
                         {
                 "doc_file_ext" = ".xlsx";
                 "doc_type" = formats;
                 "file_name" = eccbc87e4b5ce2fe28308fd9f2a7baf3;
                 "file_url" = "http://grohe.smartrac.manpoweronline.in/uploads/documents/mobile_bill_claim_format_Misc_expense.xlsx";
                 title = "Mobile Bill Claim format (Misc Expense)";
             },
                         {
                 "doc_file_ext" = ".xlsx";
                 "doc_type" = formats;
                 "file_name" = c4ca4238a0b923820dcc509a6f75849b;
                 "file_url" = "http://grohe.smartrac.manpoweronline.in/uploads/documents/out_station.xlsx";
                 title = "Out Station";
             }
         );
         "download_url" = "http://grohe.smartrac.manpoweronline.in/api/documents/download";
     };
     message = Documents;
     status = 1;
 }
 */
