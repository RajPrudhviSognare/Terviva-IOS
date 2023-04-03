//
//  KPSViewController.swift
//  Terviva
//
//  Created by Apple on 20/12/22.
//

import UIKit
import WebKit

class KPSViewController: UIViewController {

    @IBOutlet weak var contentView: WKWebView!
    @IBOutlet weak var titleLbl: UILabel!

    var header = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getToken()
        titleLbl.text = header
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func getToken() {
        SGCommonMethods.SharedInstance.showLoader()
        let url = AppUrl.BaseUrl + MethodUrl.getTokenForWeb
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let params = ["associate_id":id]

        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: url) { responseDic in
            print(responseDic)
            let status = responseDic["status"] as? Bool ?? false
            if status == true {
                let data = responseDic["data"] as? [String: AnyObject]
                
                let token = data?["token"] as? String
                self.loadWeb(token: token ?? "")
                SGCommonMethods.SharedInstance.hideLoader()

            } else {
                self.showAlert(title: projectName, message: passwordChangeError)
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
}
    
    func loadWeb(token: String) {
        SGCommonMethods.SharedInstance.showLoader()
        var urlStr = String()
        if header == HomeCategories.KPS.rawValue {
            urlStr = AppUrl.BaseUrl + MethodUrl.getWebContet + token
        } else if header == HomeCategories.Preselection.rawValue{
            urlStr = "http://terviva.smartrac.manpoweronline.in/" + MethodUrl.getWebContentForPreselection + token
        } else if header == HomeCategories.Postselection.rawValue {
            urlStr = "http://smtrac.pairserver.com/terviva/postselection/index/" + token
        } else {
            urlStr = "http://smtrac.pairserver.com/terviva/api/webview/payment_form/" + token
        }
        
        let url = URL(string: urlStr)
        contentView.load(URLRequest(url: url!))
    }
}
