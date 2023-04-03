//
//  ChangePasswordViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 18/06/22.
//

import UIKit
import CryptoKit

class ChangePasswordViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var reTypePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.oldPasswordTextField.text = ""
//        self.newPasswordTextField.text = ""
//        self.reTypePasswordTextField.text = ""
    }
    
    //MARK:- Back Button Tapped
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Submit Button Tapped
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if self.oldPasswordTextField.text != "" && self.newPasswordTextField.text != "" && self.reTypePasswordTextField.text != "" {
            if newPasswordTextField.text == self.reTypePasswordTextField.text {
                self.sendChangePasswordDetailsMethod(oldPassword: self.oldPasswordTextField.text ?? "", newPassword: self.newPasswordTextField.text ?? "", reTypePassword: self.reTypePasswordTextField.text ?? "")
            } else {
                self.showAlert(title: projectName, message: newReTypePasswordNotMatch)
            }
        } else {
            self.showAlert(title: projectName, message: fillRequiredFields)
        }
    }
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8)!)

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    func sendChangePasswordDetailsMethod(oldPassword: String, newPassword: String, reTypePassword: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let changePasswordUrl = AppUrl.BaseUrl + MethodUrl.changePasswordUrl
        let oldPassword = self.MD5(string: oldPassword)
        let newPassword = self.MD5(string: newPassword)
        let reTypePassword = self.MD5(string: reTypePassword)
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let params = ["associate_id":id, "old_password":oldPassword,"new_password":newPassword,"confirm_password":reTypePassword]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: changePasswordUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            if status == true {
                DispatchQueue.main.async {
                    self.showAlertWithTitle(withTitle: projectName, andMessage: passwordUpdate) { success in
                        self.deleteLoginDetailsMethod()
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                             let sceneDelegate = windowScene.delegate as? SceneDelegate
                             else {
                                 return
                         }
                         sceneDelegate.navigateToLoginVC()
                    }
                }
            } else {
                self.showAlert(title: projectName, message: passwordChangeError)
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
}

    func deleteLoginDetailsMethod() {
        let userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "id")
        userDefaults.set("", forKey: "isd_code")
        userDefaults.set("", forKey: "region_id")
        userDefaults.set("", forKey: "state_id")
        userDefaults.set("", forKey: "city_id")
        userDefaults.set("", forKey: "branch_id")
        userDefaults.set("", forKey: "tl_id")
        userDefaults.set("", forKey: "first_name")
        userDefaults.set("", forKey: "last_name")
        userDefaults.set("", forKey: "mobile_number")
        userDefaults.set("", forKey: "gender")
        userDefaults.set("", forKey: "isd_level")
        userDefaults.set("", forKey: "role_id")
        userDefaults.set("", forKey: "status")
        userDefaults.set("", forKey: "kyc_status")
        userDefaults.set("", forKey: "region_name")
        userDefaults.set("", forKey: "state_name")
        userDefaults.set("", forKey: "city_name")
        userDefaults.set("", forKey: "branch_name")
        userDefaults.set("", forKey: "role")
        userDefaults.synchronize()
    }
}
