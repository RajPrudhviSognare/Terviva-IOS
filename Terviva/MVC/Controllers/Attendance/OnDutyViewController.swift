//
//  OnDutyViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 18/06/22.
//

import UIKit

class OnDutyViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toolView: UIView!
    
    
    //MARK:- Variables
    var parentNavigation = UINavigationController()
    var dateStr = String()
    
    //MARK:- ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.reasonTextField.placeholder = "Add Comment"
    }
    
    //MARK:- Selected Date Button Tapped
    @IBAction func selectedDateButtonTapped(_ sender: UIButton) {
        let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
        self.selectedDateLabel.text = formatter.string(from: datePicker.date)
        self.dateStr = self.selectedDateLabel.text ?? ""
        self.datePicker.isHidden = false
        self.toolView.isHidden = false
    }
    
    //MARK:- Date Picker Tapped
    @IBAction func datePickerTapped(_ sender: UIDatePicker) {
        
    }
    
    //MARK:- Submit Button Tapped
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if self.dateStr != "" && self.reasonTextField.text != "" {
           self.sendOnDutyDeailsToServerMethod(date: self.dateStr, reason: self.reasonTextField.text ?? "")
        } else {
            self.showAlert(title: projectName, message: fillRequiredFields)
        }
    }
    
    //MARK:- Cancel Button Tapped
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.datePicker.isHidden = true
        self.toolView.isHidden = true
    }
    
    //MARK:- Done Button Tapped
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.toolView.isHidden = true
        let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
        self.selectedDateLabel.text = formatter.string(from: datePicker.date)
        self.dateStr = self.selectedDateLabel.text ?? ""
        self.datePicker.isHidden = true
    }
    
    //MARK:- Send InTime Deails ToServer Method
    func sendOnDutyDeailsToServerMethod(date: String, reason: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let onDutyUrl = AppUrl.BaseUrl + MethodUrl.attendanceEntryUrl
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let params = ["associate_id":id,"tl_id":isd_code,"outlet_id":"","attendance_type":"od","attendance_image":"","latitude":latitudeStr,"longitude":latitudeStr,"distance":"","attendance_date":date,"reason":reason,"remarks":reason,"leave_type":""]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: onDutyUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            let message = responseDic["message"] as? String ?? ""

            if status == true {
                DispatchQueue.main.async {
                    self.showAlertWithTitle(withTitle: projectName, andMessage: message) { success in
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                             let sceneDelegate = windowScene.delegate as? SceneDelegate
                             else {
                                 return
                         }
                         sceneDelegate.navigateToHomeVC()
                    }
                }
            } else {
                let message = responseDic["message"] as? String ?? ""
                self.showAlert(title: projectName, message: message)
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
    }
}
