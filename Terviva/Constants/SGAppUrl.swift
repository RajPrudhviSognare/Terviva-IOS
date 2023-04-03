//
//  SGAppUrl.swift
//  Smartrac-Grohe
//
//  Created by Happy on 15/06/22.
//

import Foundation

struct AppUrl {
    static let BaseUrl = "http://terviva.smartrac.manpoweronline.in/index.php/api/"
    static let imageBaseUrl = "http://terviva.smartrac.manpoweronline.in/uploads/locations/"
}

struct MethodUrl {
    static let loginUrl = "api/login"
    static let attendanceInfoUrl = "Employee/getEmployeeAttendanceInfo"
    static let employeeInfoUrl = "Login/Authentication"
    static let attendanceEntryUrl = "attendanceapi/attendanceEntry"
    static let messagesUrl = "message/getMessageByAssociate"
    
    static let getMessagesUrl = "message/getSendMessageByTl"
    
    static let settingsUrl = "message/getMessageByAssociate"
   
    
    static let monthlyReportdUrl = "report/monthly_attendance"
    static let monthlyDetailReportUrl = "report/getDetailsmonthlyReport"
    
    static let changePasswordUrl = "api/change_password"
    static let formatsUrl = "documents/get"
    
    
    static let teamSendGroupMessagesUrl = "target/getAssociatesByGroup"
    static let teamDashBoardAttendanceUrl = "report/getAttendanceCountDashboard"
    static let teamReportAssociateListUrl = "report/associateList_tl"
    static let teamReportMonthDetailsUrl = "report/getDetailsmonthlyReport_tl"
    static let teamGetDetialMonthReportUrl = "report/getDetailsmonthlyReport_tl"
    static let teamSendMessagesUrl = "message/setMessage"
    static let teamDeleteAssociateUrl = "message/delete_group"
    static let teamNewAddGroupUrl = "message/create_group"
    static let teamUpdateAssociateUrl = "message/update_group"
    static let teamGetAttendanceUrl = "attendanceapi/getAttendanceByTl"
    static let teamAttendanceApprovedRejectUrl = "attendanceapi/setApprovedAttendance"

    static let getTokenForWeb = "webview/get_token"
    static let getWebContet = "webview/base_form/"
    static let getWebContentForPreselection = "preselection/index/"
}

