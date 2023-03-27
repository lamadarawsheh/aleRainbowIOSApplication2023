//
//  CustomTableViewCelll.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 23/03/2023.
//

import UIKit
import Rainbow
class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageHelper().configureImageView(imageIcon)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var conversation:Conversation? = nil{
        didSet {
            if let conversation = conversation {
                nameLabel.text = conversation.peer?.displayName
                messageLabel.text = conversation.lastMessage?.body
                let firstDate = formate(conversation.lastMessage?.date ?? Date())
                let seconedDate = formate(Date())
                if firstDate.compare(seconedDate) == .orderedAscending {
                    dateLabel.text  = String(conversation.lastMessage?.date.formatted(date: .numeric, time: .shortened) ?? "")
                }
                else{
                    dateLabel.text  = String(conversation.lastMessage?.date.formatted(date: .numeric, time: .shortened).split(separator: ",").last ?? "")
                }
                
                if let contact = conversation.peer as? Contact {
                    imageIcon = ImageHelper().getImage(contact.photoData,contact.firstName ,contact.lastName,imageIcon)
                }
            }
        }
    }
    func formate(_ date:Date)->Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let stringDate = formatter.string(from: date)
        let formattedDate = formatter.date(from:stringDate)
        return formattedDate ?? Date()
    }
    
}
