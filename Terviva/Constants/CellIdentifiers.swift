//
//  CellIdentifiers.swift
//  Smartrac-Grohe
//
//  Created by Happy on 15/06/22.
//

import Foundation
import UIKit

struct StoryBoards {
    static let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    static let teamStoryBoard = UIStoryboard(name: "Team", bundle: nil)
}

struct LoginControllers {
    static let LoginViewController = "LoginViewController"
}

struct HomeControllers {
    static let HomeViewController = "HomeViewController"
    static let AttendanceViewController = "AttendanceViewController"
    static let HRMSContainerViewController = "HRMSContainerViewController"
    static let MessageViewController = "MessageViewController"
    static let ReportsViewController = "ReportsViewController"
    
    static let EmployeeInfoViewController = "EmployeeInfoViewController"
    static let LeaveBalanceViewController = "LeaveBalanceViewController"
    static let PayslipsViewController = "PayslipsViewController"
    static let FormatsViewController = "FormatsViewController"
    
    static let InTimeViewController = "InTimeViewController"
    static let OutTimeViewController = "OutTimeViewController"
    static let LeaveViewController = "LeaveViewController"
    static let OnDutyViewController = "OnDutyViewController"
    
    static let ChangePasswordViewController = "ChangePasswordViewController"
    static let SettingsViewController = "SettingsViewController"
    static let ReportsDetailsViewController = "ReportsDetailsViewController"
    static let CurrentLocationViewController = "CurrentLocationViewController"
    
    static let KPSViewController = "KPSViewController"
}

struct TableViewViewCellIdentifiers {
     static let FormatsTableViewCell = "FormatsTableViewCell"
     static let MessagesTableViewCell = "MessagesTableViewCell"
     static let LeaveBalanceTableViewCell = "LeaveBalanceTableViewCell"
     static let ReportsTableViewCell = "ReportsTableViewCell"
     static let ReportsDetailsTableViewCell = "ReportsDetailsTableViewCell"
     static let InOutTeamTableViewCell = "InOutTeamTableViewCell"
     static let EditGroupTableViewCell = "EditGroupTableViewCell"
     static let NewGroupsTableViewCell = "NewGroupsTableViewCell"
     static let TeamMessagesTableViewCell = "TeamMessagesTableViewCell"
     static let TeamMessageView = "TeamMessageView"
     static let DashBoardTableViewCell = "DashBoardTableViewCell"
     static let MeetingTableViewCell = "MeetingTableViewCell"
}

struct CollectionViewCellIdentifiers {
    static let homeCollectionViewCell = "HomeCollectionViewCell"
     static let categoryDetailsCollectionViewCell = "CategoryDetailsCollectionViewCell"
}


struct TeamControllers {
    static let AttendanceReportsViewController = "AttendanceReportsViewController"
    static let DashBoardViewController = "DashBoardViewController"
    static let AttendanceApprovalViewController = "AttendanceApprovalViewController"
    static let TeamViewViewController = "TeamViewViewController"
    static let InOutTeamViewController = "InOutTeamViewController"
    static let SendMessagesViewController = "SendMessagesViewController"
    static let CreateGroupsViewController = "CreateGroupsViewController"
    static let CreateNewGroupViewController = "CreateNewGroupViewController"
}
