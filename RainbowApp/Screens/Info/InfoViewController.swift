//
//  InfoViewController.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 26/03/2023.
//

import UIKit
import Rainbow
class InfoViewController: UIViewController {
    
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var smallIcon: UIImageView!
    @IBOutlet weak var bigIcon: UIImageView!
    @IBOutlet weak var phoneSection: UIView!
    @IBOutlet weak var phoneTextView: UITextView!
    @IBOutlet weak var emaiTextView: UITextView!
    var contact:Contact? = nil{
        didSet {
        }
    }
    override func viewDidLoad() {
        ImageHelper().configureImageView(smallIcon)
        super.viewDidLoad()
        nameLabel.text = contact?.displayName
        companyLabel.text = contact?.companyName
        title = (contact?.firstName ?? "User") + "'s information"
        smallIcon = ImageHelper().getImage(contact?.photoData,contact?.firstName ,contact?.lastName,smallIcon)
        bigIcon = ImageHelper().getImage(contact?.photoData,contact?.firstName ,contact?.lastName,bigIcon)
        ImageHelper().blurEffect(bigIcon)
        
        if let emails = contact?.emailAddresses{
            for email in emails
            {
                emaiTextView.text.append(email.address)
            }
            
        }
        if let phoneNumbers = contact?.phoneNumbers{
            phoneSection.isHidden = phoneNumbers.isEmpty
            for number in phoneNumbers
            {
                emaiTextView.text.append(number.number)
            }
            
        }
        
        if let status = contact?.presence{
            statusLabel.text = status.description
            
        }
        // Do any additional setup after loading the view.
    }
}
