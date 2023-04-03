//
//  LoginViewController.swift
//  Smartrac-Winstron
//
//  Created by Happy on 12/06/22.
//

import UIKit
import CryptoKit

class LoginViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    //MARK:- Variables
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userNameTextField.text = ""
        //"100561576"
        //"nasir.mir@lixil.com"
        //"100561576"
        //"nasir.mir@lixil.com"
        //"100561576"
        //"nasir.mir@lixil.com"
        //"100561576"
        //"100410177"
        //"100390217"
        //"100561576"
        //"100390217"
        //"kishor.shinde@lixil.com"
        //"100561576"
        //"100542114"
        self.passwordTextField.text = ""
        //"THA42114"
        self.userView.layer.cornerRadius = 30
        self.userView.layer.borderWidth = 1
        self.userView.layer.borderColor = UIColor.lightGray.cgColor
        self.userView.clipsToBounds = true
        
        self.passwordView.layer.cornerRadius = 30
        self.passwordView.layer.borderWidth = 1
        self.passwordView.layer.borderColor = UIColor.lightGray.cgColor
        self.passwordView.clipsToBounds = true
        self.userNameTextField.placeholderColor(color: .white)
        self.passwordTextField.placeholderColor(color: .white)
    }
    
    //MARK:- Login Button Tapped
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if self.userNameTextField.text != "" && self.passwordTextField.text != "" {
        self.loginDetailsServerMethod(userName: self.userNameTextField.text ?? "", password: self.passwordTextField.text ?? "")
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
    
    //MARK:- Login Details To Server Method
    func loginDetailsServerMethod(userName:String, password:String)  {
        SGCommonMethods.SharedInstance.showLoader()
        let loginUrlStr = AppUrl.BaseUrl + MethodUrl.loginUrl
        let encPassword = self.MD5(string: password)
        let params = ["device_type":"android","login_id":userName,"password":encPassword,"device_id":"","registration_id":""]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: loginUrlStr) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            if status == true {
                DispatchQueue.main.async {
                self.saveLoginDetailsMethod(userDetails: responseDic)
                   guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let sceneDelegate = windowScene.delegate as? SceneDelegate
                        else {
                            return
                    }
                    let loginData = responseDic["data"] as? [String: AnyObject] ?? [:]
                    let userData = loginData["user"] as? [String: AnyObject] ?? [:]
                    let role_id = userData["role_id"] as? String ?? ""
                    if role_id != "" {
                        if role_id == "1" {
                            sceneDelegate.navigateToHomeControllerVC(loginType: LoginType.User)
                        } else {
                            sceneDelegate.navigateToHomeControllerVC(loginType: LoginType.Team)
                        }
                    }
                }
            } else {
                self.showAlert(title: projectName, message: invalidLogin)
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }

    }
    
    func saveLoginDetailsMethod(userDetails: [String: AnyObject]) {
        print(userDetails)
        let userDefaults = UserDefaults.standard
        let loginData = userDetails["data"] as? [String: AnyObject] ?? [:]
        let userData = loginData["user"] as? [String: AnyObject] ?? [:]
        userDefaults.set(userData["id"] as? String ?? "", forKey: "id")
        userDefaults.set(userData["isd_code"] as? String ?? "", forKey: "isd_code")
        userDefaults.set(userData["region_id"] as? String ?? "", forKey: "region_id")
        userDefaults.set(userData["state_id"] as? String ?? "", forKey: "state_id")
        userDefaults.set(userData["city_id"] as? String ?? "", forKey: "city_id")
        userDefaults.set(userData["branch_id"] as? String ?? "", forKey: "branch_id")
        userDefaults.set(userData["tl_id"] as? String ?? "", forKey: "tl_id")
        userDefaults.set(userData["first_name"] as? String ?? "", forKey: "first_name")
        userDefaults.set(userData["last_name"] as? String ?? "", forKey: "last_name")
        userDefaults.set(userData["mobile_number"] as? String ?? "", forKey: "mobile_number")
        userDefaults.set(userData["gender"] as? String ?? "", forKey: "gender")
        userDefaults.set(userData["isd_level"] as? String ?? "", forKey: "isd_level")
        userDefaults.set(userData["role_id"] as? String ?? "", forKey: "role_id")
        userDefaults.set(userData["status"] as? String ?? "", forKey: "status")
        userDefaults.set(userData["kyc_status"] as? String ?? "", forKey: "kyc_status")
        userDefaults.set(userData["region_name"] as? String ?? "", forKey: "region_name")
        userDefaults.set(userData["state_name"] as? String ?? "", forKey: "state_name")
        userDefaults.set(userData["city_name"] as? String ?? "", forKey: "city_name")
        userDefaults.set(userData["branch_name"] as? String ?? "", forKey: "branch_name")
        userDefaults.set(userData["role"] as? String ?? "", forKey: "role")
        userDefaults.synchronize()
    }
}

extension UITextField {
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
            NSAttributedString.Key.font: self.font!
        ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }
}

/*
 
 {
     data =     {
         "team_lead" =         (
         );
         user =         {
             address = "<null>";
             "branch_id" = 0;
             "branch_name" = "<null>";
             "city_id" = 114;
             "city_name" = Udaipur;
             "client_code" = "<null>";
             "client_id" = "<null>";
             "client_name" = "<null>";
             email = "Shantilalpushkarna90.sp@gmail.com";
             "first_name" = Shanti;
             gender = Male;
             "gps_range" = "<null>";
             id = 319;
             "isd_code" = 100561576;
             "isd_level" = 0;
             "isd_level_name" = "<null>";
             "kyc_status" = yes;
             "last_name" = Pushkama;
             latitude = "<null>";
             logo = "<null>";
             longitude = "<null>";
             "mobile_number" = 8078618785;
             "outlet_code" = "<null>";
             "outlet_id" = "<null>";
             "outlet_name" = "<null>";
             "region_id" = 4;
             "region_name" = North;
             role = Associate;
             "role_id" = 1;
             "state_id" = 37;
             "state_name" = Rajasthan;
             status = 1;
             "tl_id" = "";
         };
     };
     message = "Login successful";
     status = 1;
 }
 
 
 
 {
     data =     {
         "team_lead" =         (
         );
         user =         {
             address = "<null>";
             "branch_id" = 0;
             "branch_name" = "<null>";
             "city_id" = 115;
             "city_name" = Jammu;
             "client_code" = "<null>";
             "client_id" = "<null>";
             "client_name" = "<null>";
             email = "nasir.mir@lixil.com";
             "first_name" = Nasir;
             gender = "";
             "gps_range" = "<null>";
             id = 229;
             "isd_code" = "nasir.mir@lixil.com";
             "isd_level" = 8;
             "isd_level_name" = Manager;
             "kyc_status" = yes;
             "last_name" = Mir;
             latitude = "<null>";
             logo = "<null>";
             longitude = "<null>";
             "mobile_number" = 9858490911;
             "outlet_code" = "<null>";
             "outlet_id" = "<null>";
             "outlet_name" = "<null>";
             "region_id" = 4;
             "region_name" = North;
             role = Teamlead;
             "role_id" = 2;
             "state_id" = 47;
             "state_name" = "J&amp;K";
             status = 1;
             "tl_id" = "";
         };
     };
     message = "Login successful";
     status = 1;
 }
 */
