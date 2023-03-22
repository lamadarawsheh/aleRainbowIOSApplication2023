//
//  CustomTableViewCell.swift
//  AlmoTest
//
//  Created by Lama Darawsheh on 22/02/2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    
    func setImage(_ data:Data){
        
        
        imageIcon.layer.borderWidth = 1.0
        imageIcon.layer.masksToBounds = false
        imageIcon.layer.borderColor = UIColor.black.cgColor
        let image = UIImage(named: "profile")
        if !data.isEmpty
        {
            
            imageIcon.image = UIImage(data: data)
        }
        else
        {
            
            imageIcon.image = image
        }
        imageIcon.layer.cornerRadius = imageIcon.frame.size.width/2
        imageIcon.clipsToBounds = true
        
        
        
    }
    
    
    
}
