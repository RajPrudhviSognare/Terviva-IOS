//
//  PayslipsViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 18/06/22.
//

import UIKit

class PayslipsViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var selectMonthLabel: UILabel!
    @IBOutlet weak var selectYearLabel: UILabel!
    @IBOutlet weak var getPaySlipsButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    //MARK:- Variables
    var parentNavigation = UINavigationController()
    var titleStr = String()
    var monthArr = [String]()
    var yearArr = [String]()
    var monthStr = String()
    var yearStr = String()
    var paySlipsStr = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.monthArr = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        
        
        self.getPaySlipsButton.layer.cornerRadius = 5
        self.getPaySlipsButton.layer.borderWidth = 1
        self.getPaySlipsButton.layer.borderColor = UIColor.lightGray.cgColor
        self.getPaySlipsButton.clipsToBounds = true
    }
    
    //MARK:- Select Month Button Tapped
    @IBAction func selectMonthButtonTapped(_ sender: UIButton) {
        SGCommonMethods.SharedInstance.showPicker(title: "Select Month", rows: [self.monthArr], initialSelection: [0], completionPicking: { (reponseArr) in
            print(reponseArr)
            self.selectMonthLabel.text = reponseArr[0]
            self.monthStr = reponseArr[0]
        }, controller: self)
    }
    
    //MARK:- Select Year Button Tapped
    @IBAction func selectYearButtonTapped(_ sender: UIButton) {
        let currentYear = Calendar.current.component(.year, from: Date())
        let previousYear = currentYear - 1
        let nextYear = currentYear - 2
        self.yearArr.append("\(currentYear)")
        self.yearArr.append("\(previousYear)")
        self.yearArr.append("\(nextYear)")
        SGCommonMethods.SharedInstance.showPicker(title: "Select Year", rows: [self.yearArr], initialSelection: [0], completionPicking: { (reponseArr) in
            print(reponseArr)
            self.selectYearLabel.text = reponseArr[0]
            self.yearStr = reponseArr[0]
        }, controller: self)
    }
    
    //MARK:- Get PaySlips Button Tapped
    @IBAction func getPaySlipsButtonTapped(_ sender: UIButton) {
        if monthStr != "" {
            if yearStr != "" {
                self.getPaySlipsDetailsFromServerMethod(url: "http://outbound.manpoweronline.in/ess/ess.asmx?wsdl")
            } else {
                self.showAlert(title: projectName, message: pleaseSelectYear)
            }
        } else {
            self.showAlert(title: projectName, message: pleaseSelectMonth)
        }
    }
    
    //MARK:- Get Pay Slips Details Method
    func getPaySlipsDetailsFromServerMethod(url: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let soapRequestHeader = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">";
        let soapMessage = soapRequestHeader +
        "<soapenv:Header/>"
        + "<soapenv:Body>"
        + "<tem:Payslip>"
        + "<tem:emp_code>" + isd_code + "</tem:emp_code>"
        + "<tem:month_name>" + self.monthStr + "</tem:month_name>"
        + "<tem:year>" + self.yearStr + "</tem:year>"
        + "</tem:Payslip>"
        + "</soapenv:Body>"
        + "</soapenv:Envelope>";
        let url = URL(string: url)
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
    
    //MARK:- Download Button Tapped
    @IBAction func dowmloadButtonTapped(_ sender: UIButton) {
        if self.paySlipsStr != "" {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                guard let url = URL(string: self.paySlipsStr) else {
                  return //be safe
                }

                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
             }
        }
    }
}

//MARK:- XML Parser Method
extension PayslipsViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.paySlipsStr += string
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        parsingCompleted()
    }
    
    func parsingCompleted() {
        DispatchQueue.main.async {
            SGCommonMethods.SharedInstance.hideLoader()
            self.downloadButton.isHidden = false
        }
    }
}

