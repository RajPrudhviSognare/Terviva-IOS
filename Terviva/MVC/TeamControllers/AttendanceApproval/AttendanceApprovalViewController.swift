//
//  AttendanceApprovalViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit

class AttendanceApprovalViewController: UIViewController {

    //MARK:- IBOUtlets
    @IBOutlet weak var inOutButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var onDutyButton: UIButton!
    
    //MARK:- ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        self.leaveButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        self.onDutyButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            appDelegate.myOrientation = .portrait
//        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func inOutButtonTapped(_ sender: UIButton) {
        guard let teamLeaveVC = StoryBoards.teamStoryBoard.instantiateViewController(withIdentifier: TeamControllers.InOutTeamViewController) as? InOutTeamViewController else {
            return
        }
        
        self.navigationController?.pushViewController(teamLeaveVC, animated: true)
    }
    
    
    @IBAction func leaveButtonTapped(_ sender: Any) {
        guard let teamLeaveVC = StoryBoards.teamStoryBoard.instantiateViewController(withIdentifier: TeamControllers.TeamViewViewController) as? TeamViewViewController else {
            return
        }
        teamLeaveVC.isNavigate = NavigateToAttendance.Leave
        self.navigationController?.pushViewController(teamLeaveVC, animated: true)
    }
    
    
    @IBAction func onDutyButtonTapped(_ sender: UIButton) {
        guard let teamLeaveVC = StoryBoards.teamStoryBoard.instantiateViewController(withIdentifier: TeamControllers.TeamViewViewController) as? TeamViewViewController else {
            return
        }
        teamLeaveVC.isNavigate = NavigateToAttendance.Meeting
        self.navigationController?.pushViewController(teamLeaveVC, animated: true)
    }
}
