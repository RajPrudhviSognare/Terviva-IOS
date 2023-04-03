//
//  LoginModel.swift
//  Smartrac-Grohe
//
//  Created by Happy on 23/06/22.
//

import Foundation


struct LoginModel : Decodable {
    var status: Bool?
    var message: String?
    var data: LoginData?
}

struct LoginData : Decodable {
    var user: [UserModel]?
}

struct UserModel : Decodable {
    var id: String?
    var isd_code: String?
    var region_id: String?
    var state_id: String?
    var city_id: String?
    var outlet_id: String?
    var tl_id: String?
    var first_name: String?
    var last_name: String?
    var mobile_number: String?
    
    
    /*{
                "id": "281",
                "isd_code": "100390217",
                "region_id": "4",
                "state_id": "51",
                "city_id": "7",
                "branch_id": "0",
                "outlet_id": null,
                "tl_id": "",
                "first_name": "Nitin",
                "last_name": "Khanna",
                "mobile_number": "9911005574",
                "email": "khanna.20@gmail.com",
                "gender": "Male",
                "isd_level": "0",
                "role_id": "1",
                "status": "1",
                "kyc_status": "yes",
                "region_name": "North",
                "state_name": "Delhi (NCR)",
                "city_name": "Gurgaon",
                "branch_name": null,
                "role": "Associate",
                "isd_level_name": null,
                "outlet_code": null,
                "outlet_name": null,
                "address": null,
                "latitude": null,
                "longitude": null,
                "gps_range": null,
                "client_id": null,
                "client_code": null,
                "client_name": null,
                "logo": null*/
    
    
}
