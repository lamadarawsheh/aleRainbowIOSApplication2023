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
        setButton()
        ImageConfigurations().configureImageView(imageIcon)
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        delegate?.viewInfo(contact!)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    var contact:Contact? = nil{
        didSet {
            if let contact = contact {
                
                
                nameLabel.text = contact.displayName
                statusLabel.text = contact.presence.description
                if let status = contact.presence{
                    statusLabel.text = contact.presence.description
                    
                }
                
                setImage(contact.photoData,contact.firstName ,contact.lastName)
                
            }
            
        }
    }
    func setImage(_ data:Data? ,_ firstName:String? ,_ lastName:String?){
        if let data = data {
            imageIcon.image = UIImage(data: data)
        }
        else {
            var name:String = ""
            if  let firstName = firstName?.first  as? Character {
                name.append(firstName)
            }
            
            if  let lastName = lastName?.first  as? Character {
                name.append(lastName)
            }
            
            imageIcon.image = ImageConfigurations().imageWith(name: name)
        }
        
    }
    
    func setButton(){
        self.infoButton.setTitle("", for: .normal)
        
    }
    
}
