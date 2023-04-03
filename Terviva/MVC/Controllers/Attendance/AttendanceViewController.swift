//
//  AttendanceViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 18/06/22.
//

import UIKit

class AttendanceViewController: UIViewController {

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
        guard let inTimeC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.InTimeViewController) as? InTimeViewController else {
            return
        }
        inTimeC.parentNavigation = self.navigationController!
        controllerArray.append(self.addNavigation(controller: inTimeC, title: "In Time"))
        
        guard let loutTimeVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.OutTimeViewController) as? OutTimeViewController else {
            return
        }
        loutTimeVC.parentNavigation = self.navigationController!
        controllerArray.append(self.addNavigation(controller: loutTimeVC, title: "Out Time"))
        
        guard let leaveVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.LeaveViewController) as? LeaveViewController else {
            return
        }
        leaveVC.parentNavigation = self.navigationController!
        controllerArray.append(self.addNavigation(controller: leaveVC, title: "Leave"))
        
        guard let onDutyVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.OnDutyViewController) as? OnDutyViewController else {
            return
        }
        onDutyVC.parentNavigation = self.navigationController!
        controllerArray.append(self.addNavigation(controller: onDutyVC, title: "On Duty"))
        let parameters: [CAPSPageMenuOption] = [
            .selectionIndicatorColor(UIColor.init(red: 174/255, green: 9/255, blue: 35/255, alpha: 1)),
            .selectedMenuItemLabelColor(UIColor.init(red: 174/255, green: 9/255, blue: 35/255, alpha: 1)),
            .unselectedMenuItemLabelColor(UIColor.init(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)),
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor.white),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .menuItemFont(UIFont.boldSystemFont(ofSize: 14)),
            
        ]
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 84, width: self.view.frame.width, height: self.view.frame.size.height - 84), pageMenuOptions: parameters)
        //CXAppConfig.sharedInstance.mainScreenSize().height
        addChild(pageMenu!)
        self.view.addSubview((self.pageMenu?.view)!)
        pageMenu?.didMove(toParent: self)
    }
    
    //MARK:- Add Navigation To Controllers
    func addNavigation(controller:UIViewController,title:String) -> UINavigationController{
        let nav : UINavigationController = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = true
        controller.title = title
        return nav
    }
}
