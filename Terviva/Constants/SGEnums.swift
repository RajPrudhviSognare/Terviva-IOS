//
//  SGEnums.swift
//  Smartrac-Grohe
//
//  Created by Happy on 16/06/22.
//

import Foundation

enum HomeCategories : String {
    case Attendance = "Attendance"
    case HRMS = "HRMS"
    case Messages = "Messages"
    case Reports = "Associates Reports"
    case KPS = "KPS"
    case Preselection = "Preselection"
    case Postselection = "Postselection"
    case Payment = "Payment"
    
    func type() -> String {
        return self.rawValue
    }
}

enum HomeCategory : String {
    case DashBoard = "DashBoard"
    case AttendanceApproval = "Attendance Approval"
    case AssociatesReports = "Associates Reports"
    case SendMessages = "Send Messages"
    case SentMessages = "Sent Messages"
    
    func type() -> String {
        return self.rawValue
    }
}

enum LoginType : String {
    case User = "User"
    case Team = "Team"
    
    func type() -> String {
        return self.rawValue
    }
}

enum SelectDate : String {
    case From = "From"
    case To = "To"
    
    func type() -> String {
        return self.rawValue
    }
}

enum CreateNewGroup : String {
    case NewGroup = "New Group"
    case UpdateGroup = "Update Group"
    
    func type() -> String {
        return self.rawValue
    }
}

enum NavigateToAttendance : String {
    case Leave = "Leave"
    case Meeting = "Meeting"
    
    func type() -> String {
        return self.rawValue
    }
}
