//
//  HRMSContainerViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 18/06/22.
//

import UIKit

class HRMSContainerViewController: UIViewController {
    
    //MARK:- Variables
    var pageMenu : CAPSPageMenu?
    var parentNavigation = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpNavTabs()
    }
    
    //MARK:- Back Button Tapped
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Navigate To Multiple View Controllers
    func setUpNavTabs(){
        var controllerArray : [UIViewController] = []
        guard let employeeInfoC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.EmployeeInfoViewController) as? EmployeeInfoViewController else {
            return
        }
        employeeInfoC.parentNavigation = self.navigationController!
        controllerArray.append(self.addNavigation(controller: employeeInfoC, title: "Employee Info"))
        
        guard let leaveVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.LeaveBalanceViewController) as? LeaveBalanceViewController else {
            return
        }
        leaveVC.parentNavigation = self.navigationController!
        controllerArray.append(self.addNavigation(controller: leaveVC, title: "Leave Balance"))
        
        guard let paySlipsVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.PayslipsViewController) as? PayslipsViewController else {
            return
        }
        paySlipsVC.parentNavigation = self.navigationController!
        controllerArray.append(self.addNavigation(controller: paySlipsVC, title: "PaySlips"))
        
        guard let reportsVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.FormatsViewController) as? FormatsViewController else {
            return
        }
        reportsVC.parentNavigation = self.navigationController!
//        controllerArray.append(self.addNavigation(controller: reportsVC, title: "Formats"))
        let parameters: [CAPSPageMenuOption] = [
            .selectionIndicatorColor(UIColor.init(red: 174/255, green: 9/255, blue: 35/255, alpha: 1)),
            .selectedMenuItemLabelColor(UIColor.init(red: 174/255, green: 9/255, blue: 35/255, alpha: 1)),
            .unselectedMenuItemLabelColor(UIColor.init(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)),
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor.white),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .menuItemWidth(120),
            .menuItemFont(UIFont.boldSystemFont(ofSize: 14))
        ]
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 84, width: self.view.frame.width, height: self.view.frame.size.height - 84), pageMenuOptions: parameters)
        //CXAppConfig.sharedInstance.mainScreenSize().height
        self.view.addSubview((self.pageMenu?.view)!)
    }
    
    //MARK:- Add Navigation To Controllers
    func addNavigation(controller:UIViewController,title:String) -> UINavigationController{
        let nav : UINavigationController = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = true
        controller.title = title
        return nav
    }

}
