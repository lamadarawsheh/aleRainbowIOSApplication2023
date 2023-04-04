//
//  CustomTableViewCelll.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 23/03/2023.
//

import UIKit
import Rainbow
class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var unreadMessagesView: UIView!
    @IBOutlet weak var unreadMessagesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageHelper().configureImageView(imageIcon)
        unreadMessagesView.layer.cornerRadius = unreadMessagesView.frame.size.width/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var conversation:Conversation? = nil{
        didSet {
            if let conversation = conversation {
                nameLabel.text = conversation.peer?.displayName
                messageLabel.text = conversation.lastMessage?.body
                let firstDate = DateFormatterr().formate(conversation.lastMessage?.date ?? Date())
                let seconedDate = DateFormatterr().formate(Date())
                if firstDate.compare(seconedDate) == .orderedAscending {
                    dateLabel.text  = String(conversation.lastMessage?.date.formatted(date: .numeric, time: .shortened) ?? "")
                }
                else{
                    dateLabel.text  = String(conversation.lastMessage?.date.formatted(date: .numeric, time: .shortened).split(separator: ",").last ?? "")
                }
                
                if let contact = conversation.peer as? Contact {
                    imageIcon.image = ImageHelper().getImage(contact.photoData,contact.firstName ,contact.lastName)
                }
                unreadMessagesLabel.text = String(conversation.unreadMessagesCount)
                unreadMessagesView.isHidden = conversation.unreadMessagesCount == 0
            }
        }
    }
}
