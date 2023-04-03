//
//  LeaveBalanceViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 18/06/22.
//

import UIKit

class LeaveBalanceViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var leaveTablview: UITableView!
    
    //MARK:- Variables
    var parentNavigation = UINavigationController()
    var leaveStr = String()
    
    //MARK:- ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadXibNibFileMethod()
        self.leaveTablview.delegate = self
        self.leaveTablview.dataSource = self
    }
    
    //MARK:- LoadXib Nib File Method
    func loadXibNibFileMethod()  {
        let detailsXibNib = UINib(nibName: TableViewViewCellIdentifiers.LeaveBalanceTableViewCell, bundle: nil)
        self.leaveTablview.register(detailsXibNib, forCellReuseIdentifier: TableViewViewCellIdentifiers.LeaveBalanceTableViewCell)
        self.getLeaveBalanceDetailsFromServerMethod(url: "http://outbound.manpoweronline.in/ess/ess.asmx?wsdl")
    }
    
    //MARK:- Get Leave Balance Details Method
    func getLeaveBalanceDetailsFromServerMethod(url: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let soapRequestHeader = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">";
        let soapMessage = soapRequestHeader +
       // <soapenv:Header/><soapenv:Body><tem:LeaveBalance><tem:emp_code>100390217</tem:emp_code></tem:LeaveBalance></soapenv:Body></soapenv:Envelope>"
        "<soapenv:Header/>"
        + "<soapenv:Body>"
        + "<tem:LeaveBalance>"
        //+"<tem:emp_code>"+100172254+"</tem:emp_code>"
        + "<tem:emp_code>" + isd_code + "</tem:emp_code>"
        + "</tem:LeaveBalance>"
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
}

//MARK:- UITableView Delegate and DataSource Methods
extension LeaveBalanceViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let leavesCell = self.leaveTablview.dequeueReusableCell(withIdentifier: TableViewViewCellIdentifiers.LeaveBalanceTableViewCell, for: indexPath) as? LeaveBalanceTableViewCell else {
            return UITableViewCell()
        }
        leavesCell.leaveValueLabel.text = self.leaveStr
        leavesCell.selectionStyle = .none
        return leavesCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

//MARK:- XML Parser Method
extension LeaveBalanceViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.leaveStr = string
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        parsingCompleted()
    }
    
    func parsingCompleted() {
        SGCommonMethods.SharedInstance.hideLoader()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.leaveTablview.reloadData()
         }
    }
}

