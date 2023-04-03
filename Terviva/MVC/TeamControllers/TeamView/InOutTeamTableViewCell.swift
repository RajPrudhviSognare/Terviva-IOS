//
//  InOutTeamTableViewCell.swift
//  Smartrac-Grohe
//
//  Created by Happy on 25/06/22.
//

import UIKit

class InOutTeamTableViewCell: UITableViewCell, UITextFieldDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeTimeLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var variationLabel: UILabel!
    @IBOutlet weak var checkImageview: UIImageView!
    @IBOutlet weak var profileImageview: UIImageView!
    var commentsDelegate: InOutDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commentTextField.delegate = self
        self.commentTextField.addTarget(self, action: #selector(commentsTapped(sender:)), for: .valueChanged)
    }
    
    @objc func commentsTapped(sender:UITextField)  {
        //self.commentsDelegate?.getCommentsDetails(comments: self.commentTextField.text ?? "")
    }

    @IBAction func commentsTextFieldTapped(_ sender: UITextField) {
        //self.commentsDelegate?.getCommentsDetails(comments: self.commentTextField.text ?? "")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.commentsDelegate?.getCommentsDetails(comments: self.commentTextField.text ?? "")
        return true
    }
}
