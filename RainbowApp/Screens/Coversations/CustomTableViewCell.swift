//
//  CustomTableViewCell.swift
//  AlmoTest
//
//  Created by Lama Darawsheh on 22/02/2023.
//

import UIKit
import Rainbow
class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    var contacts:[Contact]? = nil
    var conversation:Conversation? = nil{
        didSet {
            if let conversation = conversation {
                nameLabel.text = conversation.peer?.displayName
                
                messageLabel.text = conversation.lastMessage?.body
                dateLabel.text  = String(conversation.lastMessage?.date.formatted(date: .numeric, time: .shortened).split(separator: ",").last ?? "")
                let contact =  contacts?.first(where: {$0.rainbowID == conversation.peer?.rainbowID})
                setImage(contact?.photoData)
                
            }
            
        }
    }
    func setImage(_ data:Data?){
        imageIcon.layer.borderWidth = 1.0
        imageIcon.layer.masksToBounds = false
        imageIcon.layer.borderColor = UIColor.black.cgColor
        let image = UIImage(named: "profile")
        if let data = data {
            if !data.isEmpty
            {
                imageIcon.image = UIImage(data: data)
            }
        }
        else {
            imageIcon.image = image
        }
        imageIcon.layer.cornerRadius = imageIcon.frame.size.width/2
        imageIcon.clipsToBounds = true
        
    }
    
    
    
}
