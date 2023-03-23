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
                    setImage(contact.photoData,contact.firstName ,contact.lastName)
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
    
    func setImage(_ data:Data? ,_ firstName:String? ,_ lastName:String?){
        var name:String = ""
        if  let firstName = firstName?.first  as? Character {
            name.append(firstName)
        }
        if  let lastName = lastName?.first  as? Character {
            name.append(lastName)
        }
        
        let image =  imageWith(name: name)
        if let data = data {
            if !data.isEmpty
            {
                imageIcon.image = UIImage(data: data)
            }
        }
        else {
            imageIcon.image = image
        }
        
    }
    func configureImageView(){
        imageIcon.layer.borderWidth = 1.0
        imageIcon.layer.masksToBounds = false
        imageIcon.layer.borderColor = UIColor.black.cgColor
        imageIcon.layer.cornerRadius = imageIcon.frame.size.width/2
        imageIcon.clipsToBounds = true
    }
    
    func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .lightGray
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        nameLabel.text = name
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    
    
}
