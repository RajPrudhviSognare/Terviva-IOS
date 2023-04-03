//
//  SettingsViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 18/06/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var firstPhoneNumberTextField: UITextField!
    @IBOutlet weak var secondPhoneNumberTextField: UITextField!
    @IBOutlet weak var thirdPhoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Back Button Tapped
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Submit Button Tapped
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if self.firstPhoneNumberTextField.text != "" && self.secondPhoneNumberTextField.text != "" && self.thirdPhoneNumberTextField.text != "" {
            self.saveSettingDetailsMethod( firstPhoneNumber: self.firstPhoneNumberTextField.text ?? "", secondPhoneNumber: self.firstPhoneNumberTextField.text ?? "", threePhoneNumber: self.firstPhoneNumberTextField.text ?? "")
        } else {
            self.showAlert(title: projectName, message: fillRequiredFields)
        }
    }
    
    func saveSettingDetailsMethod(firstPhoneNumber: String, secondPhoneNumber: String, threePhoneNumber: String) {
        self.showAlertWithTitle(withTitle: projectName, andMessage: passwordUpdate) { success in
            let userDefaults = UserDefaults.standard
            userDefaults.set(firstPhoneNumber, forKey: "firstPhoneNumber")
            userDefaults.set(secondPhoneNumber, forKey: "secondPhoneNumber")
            userDefaults.set(threePhoneNumber, forKey: "threePhoneNumber")
            userDefaults.synchronize()
        }
    }
}
