//
//  UIViewControllersExtensions.swift
//  Smartrac-Grohe
//
//  Created by Happy on 15/06/22.
//

import Foundation
import UIKit

extension UIViewController {
    
   func setNavigationBarProperties(color:UIColor, title:String) {
       self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    // use this for all over the project
    func showAlert(withTitle title:String, andMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTitle(withTitle title:String, andMessage message:String,completion:@escaping (_ success:Bool)->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (alert) in
            completion(true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithNoInterNetConnection() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (alert) in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithConformation(withTitle title:String, andMessage message:String,completion:@escaping (_ success:Bool)->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (alert) in
            completion(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            completion(false)
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithConformationMethod(withTitle title:String, andMessage message:String,completion:@escaping (_ success:Bool)->Void) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let action = UIAlertAction(title: "Accept", style: .default) { (alert) in
               completion(true)
           }
           let cancelAction = UIAlertAction(title: "Decline", style: .default) { (alert) in
               completion(false)
           }
           alert.addAction(cancelAction)
           alert.addAction(action)
           present(alert, animated: true, completion: nil)
       }
    
    func showAlertForEnableNotification(withTitle title:String, andMessage message:String,completion:@escaping (_ success:Bool)->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Settings", style: .default) { (alert) in
            completion(true)
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .default) { (alert) in
            completion(false)
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
//    func showActionSheetMethod(withTitle title:String, andMessage message:String,completion:@escaping (_ success:Bool)->Void){
//        let alertController = UIAlertController(title: Localization(string: "ProjectName"), message: nil, preferredStyle: .actionSheet)
//        let takePhotoAction = UIAlertAction(title: Localization(string: "camera"), style: .default) { (UIAlertAction) in
//            self.cameraPresent()
//        }
//        let libraryAction = UIAlertAction(title: Localization(string: "Choose From Library"), style: .default) { (UIAlertAction) in
//            self.galleryPresent()
//        }
//
//        let cancelAction = UIAlertAction(title: Localization(string: "Cancel"), style: .cancel)
//        { (UIAlertAction) in
//            self.dismiss(animated: true, completion: nil)
//        }
//        alertController.addAction(takePhotoAction)
//        alertController.addAction(libraryAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
   
    
    
    func setTextFieldattributedPlaceholder(placeHolderName:String,placeHolderColor:UIColor,textFieldIs:UITextField) {
        textFieldIs.attributedPlaceholder = NSAttributedString(string: placeHolderName, attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
    }
    
    func forgotPasswordSetTextFieldattributedPlaceholder(placeHolderName:String,placeHolderColor:UIColor,textFieldIs:UITextField) {
        textFieldIs.attributedPlaceholder = NSAttributedString(string: placeHolderName, attributes: [NSAttributedString.Key.foregroundColor:placeHolderColor])
    }
    
    func showLoader(message:String) {
//        progress = MBProgressHUD.showAdded(to: view, animated: true)
//        progress.mode = MBProgressHUDMode.indeterminate
//        progress.label.text = message
//        progress.show(animated: true)
    }
    
    func hideLoader() {
       // MBProgressHUD.hide(for: view, animated: true)
    }
    
    func setButtonProperties(btnBackGroundColor:UIColor,cornerRadious:Int,borderWidth:Int,titleColor:UIColor,btn:UIButton) {
        btn.backgroundColor = btnBackGroundColor
        btn.titleLabel?.textColor = titleColor
        btn.layer.borderWidth = CGFloat(borderWidth)
        btn.layer.cornerRadius = CGFloat(cornerRadious)
    }
    
    func moveToProfile()  {
        /*let profileView = UIStoryboard.getDashboardStoryboard().instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        //let navCntl = UINavigationController(rootViewController: profileView)
        self.present(profileView, animated: true, completion: nil)*/
    }
    
    func createButtonOnTableView(tableView:UITableView,message:String) {
        let popButton = UIButton()
        popButton.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width - 40, height: 50)
        popButton.backgroundColor = UIColor.white
        popButton.setTitle(message, for: .normal)
       // popButton.setTitleColor(RGColors.ButtonsColor, for: .normal)
        popButton.addTarget(self, action: #selector(navigateToLoginControllerMethod), for: .touchUpInside)
        tableView.backgroundView = popButton
            //self.createLable(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height), message: message)
    }
    
    //MARK:- Navigate to Login Controler Method
   @objc func navigateToLoginControllerMethod() {
        guard let loginVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: LoginControllers.LoginViewController) as? LoginViewController else {
            return
        }
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func showNetworkErrorAlertMethod() {
        let networkView = UIView(frame: CGRect(x: 0, y: -90, width: self.view.frame.size.width, height: 90))
        networkView.backgroundColor = UIColor.white
        networkView.backgroundColor?.withAlphaComponent(0.7)
        networkView.tag = 100
        let okButton: UIButton = UIButton()
        okButton.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        //okButton.setBackgroundImage(RGImages.AppLogoIcon, for: .normal)
        okButton.setTitleColor(UIColor.white, for: .normal)
        okButton.titleLabel?.font = UIFont(name: "Alef", size: 18)
        networkView.addSubview(okButton)
        okButton.addTarget(self, action: #selector(okClicked), for: .touchUpInside)
        
        let width = okButton.frame.size.width
        let alertLabel: UILabel = UILabel()
        alertLabel.frame = CGRect(x: okButton.frame.size.width,
                                  y: 35, width: self.view.frame.size.width - (width + 10), height: 55)
        alertLabel.text = "Couldn't connect to the server. Check your network connection."
        alertLabel.textAlignment = .left
        alertLabel.font = UIFont(name: "Alef", size: 14)
        alertLabel.textColor = UIColor.white
        alertLabel.numberOfLines = 0
        alertLabel.backgroundColor = UIColor.clear
        networkView.addSubview(alertLabel)
        
        
        let alertTitle: UILabel = UILabel()
        alertTitle.frame = CGRect(x: okButton.frame.size.width,
                                  y: 15, width: self.view.frame.size.width - width, height: 30)
        alertTitle.text = "Network error"
        alertTitle.textAlignment = .left
        alertTitle.font = UIFont(name: "Alef", size: 16)
        alertTitle.textColor = UIColor.white
        alertTitle.numberOfLines = 0
        alertTitle.backgroundColor = UIColor.clear
        networkView.addSubview(alertTitle)
        
        
        if UIApplication.shared.keyWindow?.viewWithTag(100) != nil {
            UIApplication.shared.keyWindow?.viewWithTag(100)?.removeFromSuperview()
        }
        UIApplication.shared.keyWindow?.addSubview(networkView)
        
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            networkView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 90)
        }, completion: { (finished: Bool) in
            //print(finished)
        })
    }
}

protocol ShowAlert {}

extension ShowAlert where Self: UIViewController {
    func showAlert(title: String?, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController: ShowAlert {}
/////////////
/////// ALERT /////
protocol ShowNetworkAlert {
    
}

extension UIViewController: ShowNetworkAlert {
    @objc func okClicked() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            UIApplication.shared.keyWindow?.viewWithTag(100)?.removeFromSuperview()
        }, completion: { (finished: Bool) in
            //print(finished)
        })
    }
}
//extension UITableView {
//    func setEmptyMessage(_ message: String) {
//        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
//        messageLabel.text = message
//        messageLabel.textColor = .black
//        messageLabel.numberOfLines = 0;
//        messageLabel.textAlignment = .center;
//        messageLabel.font = UIFont(name: "Helvetica-Neue", size: 15)
//        messageLabel.sizeToFit()
//
//        self.backgroundView = messageLabel;
//        self.separatorStyle = .none;
//    }
//
//    func restore() {
//        self.backgroundView = nil
//        self.separatorStyle = .singleLine
//    }
//}

extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float,corner:CGFloat) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.cornerRadius = corner
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = SGColors.App_Theme
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
       // messageLabel.textColor = RGColors.ButtonsColor
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        //self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        //self.separatorStyle = .singleLine
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension String {

    public func charAt(_ i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }

    public subscript (i: Int) -> String {
        return String(self.charAt(i) as Character)
    }

    public subscript (r: Range<Int>) -> String {
        return substring(with: self.index(self.startIndex, offsetBy: r.lowerBound)..<self.index(self.startIndex, offsetBy: r.upperBound))
    }

    public subscript (r: CountableClosedRange<Int>) -> String {
        return substring(with: self.index(self.startIndex, offsetBy: r.lowerBound)..<self.index(self.startIndex, offsetBy: r.upperBound))
    }

}
