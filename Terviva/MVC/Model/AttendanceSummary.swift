//
//  AttendanceSummary.swift
//  Smartrac-Grohe
//
//  Created by Happy on 15/06/22.
//

import Foundation

struct AttandanceSummaryModel : Decodable {
    var Data: Data?
}

struct Data : Decodable {
    var Result: [Result]?
}

struct Result : Decodable {
    var Att_date: String?
    var Empid: String?
    var AttendanceDate: String?
    var Att_shift: String?
    var Att_status: String?
    var Worked_hrs: Int?
    var Early_minutes: Int?
    var Late_minutes: Int?
    var IN: Int?
    var OUT: Int?
}
