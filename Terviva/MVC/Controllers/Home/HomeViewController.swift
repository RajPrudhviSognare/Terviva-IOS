//
//  HomeViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 15/06/22.
//

import UIKit
import MapKit

var latitudeStr = String()
var longitudeStr = String()

class HomeViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
   
    //MARK:- Variables
    var categoryArr = [String]()
    var menuImageArr = [String]()
    var backgroundColorArr: [UIColor]?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var loginType = LoginType.User
    
    //MARK:- VieDidLoa Method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLabel.text = projectName
        self.projectNameLabel.text = projectName
        let userDefaults = UserDefaults.standard
        let firstName = userDefaults.object(forKey: "first_name") as? String ?? ""
        let lastName = userDefaults.object(forKey: "last_name") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        self.welcomeLabel.text = "Hello: \(firstName) \(lastName)(\(isd_code))"
        userDefaults.synchronize()
        self.loadXibNibFileMethod()
        //self.backgroundColorArr = [SGColors.App_Theme]
        //,SGColors.presentColor?.cgColor,SGColors.AbsentColor?.cgColor,SGColors.HolidayColor?.cgColor
        switch self.loginType {
        case .User:
            self.menuImageArr = [SGImages.attendance,SGImages.HRMS,SGImages.reports, SGImages.ksp, SGImages.attendance, SGImages.ksp, SGImages.paymet]
            self.categoryArr = [HomeCategories.Attendance.rawValue,HomeCategories.HRMS.rawValue,HomeCategories.Reports.rawValue, HomeCategories.KPS.rawValue, HomeCategories.Preselection.rawValue, HomeCategories.Postselection.rawValue, HomeCategories.Payment.rawValue]
        default:
            self.menuImageArr = [SGImages.attendance,SGImages.HRMS,SGImages.reports,SGImages.reports]
            self.categoryArr = [HomeCategory.DashBoard.rawValue,HomeCategory.AttendanceApproval.rawValue,HomeCategory.AssociatesReports.rawValue, HomeCategory.SentMessages.rawValue]
        }
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
   //MARK:- Load XibNib File Method
    func loadXibNibFileMethod()  {
        let homeCellXibNib = UINib(nibName: CollectionViewCellIdentifiers.homeCollectionViewCell, bundle: nil)
        self.homeCollectionView.register(homeCellXibNib, forCellWithReuseIdentifier: CollectionViewCellIdentifiers.homeCollectionViewCell)
    }
    
    //MARK:- Profile Button Tapped
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        guard let profileVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.ChangePasswordViewController) as? ChangePasswordViewController else {
            return
        }
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    //MARK:- Menu Button Tapped
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        guard let currentLocationVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.CurrentLocationViewController) as? CurrentLocationViewController else {
            return
        }
        
        self.navigationController?.pushViewController(currentLocationVC, animated: true)
    }
    
    //MARK:- Logout Button Tapped
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        self.logoutView.isHidden = false
    }
    
    //MARK:- Logout Ok Button Tapped
    @IBAction func logoutOkButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.deleteLoginDetailsMethod()
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                else {
                    return
            }
            sceneDelegate.navigateToLoginVC()
        }
    }
    
    func deleteLoginDetailsMethod() {
        let userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "id")
        userDefaults.set("", forKey: "isd_code")
        userDefaults.set("", forKey: "region_id")
        userDefaults.set("", forKey: "state_id")
        userDefaults.set("", forKey: "city_id")
        userDefaults.set("", forKey: "branch_id")
        userDefaults.set("", forKey: "tl_id")
        userDefaults.set("", forKey: "first_name")
        userDefaults.set("", forKey: "last_name")
        userDefaults.set("", forKey: "mobile_number")
        userDefaults.set("", forKey: "gender")
        userDefaults.set("", forKey: "isd_level")
        userDefaults.set("", forKey: "role_id")
        userDefaults.set("", forKey: "status")
        userDefaults.set("", forKey: "kyc_status")
        userDefaults.set("", forKey: "region_name")
        userDefaults.set("", forKey: "state_name")
        userDefaults.set("", forKey: "city_name")
        userDefaults.set("", forKey: "branch_name")
        userDefaults.set("", forKey: "role")
        userDefaults.synchronize()
    }
    
    //MARK:- Logout Cancel Button Tapped
    @IBAction func logoutCancelButtonTapped(_ sender: UIButton) {
        self.logoutView.isHidden = true
    }
}

//MARK:- UICollectionView Delegate and DataSource Methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.homeCollectionView.frame.size.width/2 - 8, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let homeCell = self.homeCollectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.homeCollectionViewCell, for: indexPath) as? HomeCollectionViewCell else {
            return  UICollectionViewCell()
        }
        homeCell.titleLabel.text = self.categoryArr[indexPath.row]
        //homeCell.containerView.backgroundColor = self.backgroundColorArr[indexPath.row]
        homeCell.logoImageView.image = UIImage(named: self.menuImageArr[indexPath.row])
        switch self.loginType {
        case .User:
            switch indexPath.row {
            case 0:
                homeCell.containerView.backgroundColor = SGColors.attendanceColor
            case 1:
                homeCell.containerView.backgroundColor = SGColors.HRMSColor
            case 2:
                homeCell.containerView.backgroundColor = SGColors.ReportsColor
            case 3:
                homeCell.containerView.backgroundColor = SGColors.MessagesColor
            case 4:
                homeCell.containerView.backgroundColor = SGColors.attendanceColor
            case 5:
                homeCell.containerView.backgroundColor = SGColors.HRMSColor
            case 6:
                homeCell.containerView.backgroundColor = SGColors.ReportsColor

            default:
                break
            }
        default:
            switch indexPath.row {
            case 0:
                homeCell.containerView.backgroundColor = SGColors.attendanceColor
            case 1:
                homeCell.containerView.backgroundColor = SGColors.HRMSColor
            case 2:
                homeCell.containerView.backgroundColor = SGColors.ReportsColor
            case 3:
                homeCell.containerView.backgroundColor = SGColors.MessagesColor
            default:
                break
            }
        }
        return homeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.loginType {
        case .User:
            let categoryObj = self.categoryArr[indexPath.row]
           switch categoryObj {
            case HomeCategories.Attendance.rawValue:
                guard let attendanceSummaryVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.AttendanceViewController) as? AttendanceViewController else {
                    return
                }
                //attendanceSummaryVC.titleStr = HomeCategories.AttendanceSummary.rawValue
                self.navigationController?.pushViewController(attendanceSummaryVC, animated: true)
            case HomeCategories.HRMS.rawValue:
                guard let HRMSVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.HRMSContainerViewController) as? HRMSContainerViewController else {
                    return
                }
                //employeeInfoVC.titleStr = HomeCategories.EmployeeInfo.rawValue
                self.navigationController?.pushViewController(HRMSVC, animated: true)
         
           case HomeCategories.KPS.rawValue:
               guard let kpsVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.KPSViewController) as? KPSViewController else {
                   return
               }
               kpsVC.header = HomeCategories.KPS.rawValue
               //employeeInfoVC.titleStr = HomeCategories.EmployeeInfo.rawValue
               self.navigationController?.pushViewController(kpsVC, animated: true)
           case HomeCategories.Preselection.rawValue:
               guard let vc = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.KPSViewController) as? KPSViewController else {
                   return
               }
               vc.header = HomeCategories.Preselection.rawValue
               self.navigationController?.pushViewController(vc, animated: true)
               
           case HomeCategories.Postselection.rawValue:
               guard let vc = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.KPSViewController) as? KPSViewController else {
                   return
               }
               vc.header = HomeCategories.Postselection.rawValue
               self.navigationController?.pushViewController(vc, animated: true)
               

               
           case HomeCategories.Payment.rawValue:
               guard let vc = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.KPSViewController) as? KPSViewController else {
                   return
               }
               vc.header = HomeCategories.Payment.rawValue
               self.navigationController?.pushViewController(vc, animated: true)
               

           default:
               guard let reportsVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.ReportsViewController) as? ReportsViewController else {
                   return
               }
               //employeeInfoVC.titleStr = HomeCategories.EmployeeInfo.rawValue
               self.navigationController?.pushViewController(reportsVC, animated: true)
            }
        default:
           let categoryObj = self.categoryArr[indexPath.row]
           switch categoryObj {
            case HomeCategory.DashBoard.rawValue:
                guard let dashBoardVC = StoryBoards.teamStoryBoard.instantiateViewController(withIdentifier: TeamControllers.DashBoardViewController) as? DashBoardViewController else {
                    return
                }
                //attendanceSummaryVC.titleStr = HomeCategories.AttendanceSummary.rawValue
                self.navigationController?.pushViewController(dashBoardVC, animated: true)
            case HomeCategory.AttendanceApproval.rawValue:
                guard let attendanceApprovalVC = StoryBoards.teamStoryBoard.instantiateViewController(withIdentifier: TeamControllers.AttendanceApprovalViewController) as? AttendanceApprovalViewController else {
                    return
                }
                //employeeInfoVC.titleStr = HomeCategories.EmployeeInfo.rawValue
                self.navigationController?.pushViewController(attendanceApprovalVC, animated: true)
           case HomeCategory.AssociatesReports.rawValue:
               guard let attendanceReportsVC = StoryBoards.teamStoryBoard.instantiateViewController(withIdentifier: TeamControllers.AttendanceReportsViewController) as? AttendanceReportsViewController else {
                   return
               }
               //employeeInfoVC.titleStr = HomeCategories.EmployeeInfo.rawValue
               self.navigationController?.pushViewController(attendanceReportsVC, animated: true)
            default:
               guard let messagesVC = StoryBoards.mainStoryBoard.instantiateViewController(withIdentifier: HomeControllers.MessageViewController) as? MessageViewController else {
                   return
               }
               
               self.navigationController?.pushViewController(messagesVC, animated: true)
            }
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        latitudeStr = lat.description
        longitudeStr = long.description
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                
                print("placemarks",placemarks!)
                let pm = placemarks?[0]
                
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
}
