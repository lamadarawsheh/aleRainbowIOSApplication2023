//
//  ContactsTableViewCell.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 26/03/2023.
//

import UIKit
import Rainbow
class ContactsTableViewCell: UITableViewCell {
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    var delegate: ViewActionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.infoButton.setTitle("", for: .normal)
        ImageHelper().configureImageView(imageIcon)
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        delegate?.viewContactInfo(contact!)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    var contact:Contact? = nil{
        didSet {
            if let contact = contact {
                nameLabel.text = contact.displayName
                
                if let status = contact.presence{
                    statusLabel.text = status.description
                }
                imageIcon.image = ImageHelper().getImage(contact.photoData,contact.firstName ,contact.lastName)
                
            }
        }
    }
}
