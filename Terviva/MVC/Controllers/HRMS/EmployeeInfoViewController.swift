//
//  EmployeeInfoViewController.swift
//  Smartrac-Winstron
//
//  Created by Happy on 13/06/22.
//

import UIKit

class EmployeeInfoViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var employeeCodeLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var fatherNameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var dateOfJoiningTextField: UILabel!
    @IBOutlet weak var PFNumberLabel: UILabel!
    @IBOutlet weak var PFUANLabel: UILabel!
    @IBOutlet weak var clientIDLabel: UILabel!
    @IBOutlet weak var ESICNumberLabel: UILabel!
    @IBOutlet weak var PANLabel: UILabel!
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mailingAddressLabel: UILabel!
    @IBOutlet weak var permAddressLabel: UILabel!
    @IBOutlet weak var mobile1label: UILabel!
    @IBOutlet weak var mobile2Label: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK:- Variables
    var parentNavigation = UINavigationController()
    var titleStr = String()
    var texttValue = String()
    var empCode = String()
    var empName = String()
    var fatherName = String()
    var DOB = String()
    var DOJ = String()
    var PFNumber = String()
    var PFUAN = String()
    var ESICNumber = String()
    var PAN = String()
    var ClientName = String()
    var email = String()
    var mailingAddress = String()
    var permAddress = String()
    var mobile1 = String()
    var mobile2 = String()
    var satatus = String()
    var employeeInfo = [String]()
    var count = 0
    var xmlDict = [String: Any]()
    var xmlDictArr = [[String: Any]]()
    var currentElement = ""
    
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.titleLabel.text = self.titleStr
        self.getEmployeeInfoMethod(employeeurl: "http://outbound.manpoweronline.in/ess/ess.asmx?wsdl")
    }
    
    //MARK:- Back Button Tapped
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getEmployeeInfoMethod(employeeurl: String)  {
        SGCommonMethods.SharedInstance.showLoader()
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let soapRequestHeader = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">";
        let soapMessage = soapRequestHeader +
        "<soapenv:Header/>"
        + "<soapenv:Body>"
        + "<tem:EmployeeInformation>"
        //+"<tem:emp_code>"+100172254+"</tem:emp_code>"
        + "<tem:emp_code>" + isd_code + "</tem:emp_code>"
        + "</tem:EmployeeInformation>"
        + "</soapenv:Body>"
        + "</soapenv:Envelope>";
        let url = URL(string: employeeurl)
        let theRequest = NSMutableURLRequest(url: url!)
        let msgLength = soapMessage.count
        theRequest.addValue("text/xml;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let session = URLSession.shared
        let task = session.dataTask(with: theRequest as URLRequest, completionHandler: { (data, response, error) in
            
            guard error == nil && data != nil else {
                print("Connection error or data is nil !")
                return
            }
            let dataString = String(data: data!, encoding: .utf8)
            guard let jsonData = dataString?.data(using: .utf8) else {
                return
            }
            let XMLparser = XMLParser(data: jsonData)
            XMLparser.delegate = self
            XMLparser.parse()
            XMLparser.shouldResolveExternalEntities = true
        })
        task.resume()
    }
}

extension EmployeeInfoViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let empDetails = string ?? ""
        self.employeeInfo.append(empDetails)
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        parsingCompleted()
    }
    func parsingCompleted() {
        print(self.employeeInfo)
        SGCommonMethods.SharedInstance.hideLoader()
        if self.employeeInfo.count != 0 {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.employeeCodeLabel.text = self.employeeInfo[0]
            self.employeeNameLabel.text = self.employeeInfo[1]
            self.fatherNameLabel.text = self.employeeInfo[2]
            self.dateOfBirthLabel.text = self.employeeInfo[3]
            self.dateOfJoiningTextField.text = self.employeeInfo[4]
            self.PFNumberLabel.text = self.employeeInfo[5]
            self.PFUANLabel.text = self.employeeInfo[6]
            self.ESICNumberLabel.text = self.employeeInfo[7]
            self.PANLabel.text = self.employeeInfo[8]
            self.clientNameLabel.text = self.employeeInfo[9]
            self.emailLabel.text = self.employeeInfo[10]
            self.mailingAddressLabel.text = self.employeeInfo[11]
            self.permAddressLabel.text = self.employeeInfo[12]
            self.mobile1label.text = self.employeeInfo[13]
            self.mobile2Label.text = (self.employeeInfo.count > 14) ? self.employeeInfo[14] : ""
            self.statusLabel.text = (self.employeeInfo.count > 15) ? self.employeeInfo[15] : ""
         }
        }
    }
}

