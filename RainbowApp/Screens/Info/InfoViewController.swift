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
    
    @IBOutlet weak var phoneTextView: UITextView!
    @IBOutlet weak var emaiTextView: UITextView!
    var contact:Contact? = nil{
        didSet {
            
        }
    }
    override func viewDidLoad() {
        configureItems()
        ImageConfigurations().configureImageView(smallIcon)
        
        super.viewDidLoad()
        
        nameLabel.text = contact?.displayName
        companyLabel.text = contact?.companyName
        title = (contact?.firstName ?? "User") + "'s information"
        setImage(contact?.photoData,contact?.firstName ,contact?.lastName,smallIcon)
        setImage(contact?.photoData,contact?.firstName ,contact?.lastName,bigIcon)
        ImageConfigurations().blurEffect(bigIcon)
        if let emails = contact?.emailAddresses
        {
            for email in emails
            {
                emaiTextView.text.append(email.address)
            }
            
        }
        if let phoneNumbers = contact?.phoneNumbers
        {
            for number in phoneNumbers
            {
                emaiTextView.text.append(number.number)
            }
            
        }
        if let status = contact?.presence{
            statusLabel.text = contact?.presence.description
            
        }
        // Do any additional setup after loading the view.
    }
    func configureItems(){
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        
        
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        let image = UIImage(systemName: "chevron.backward")
        backButton.setBackgroundImage(image,for: .normal)
        
        backButton.addTarget(self, action: #selector(getBack(sender: )), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        
    }
    func setImage(_ data:Data? ,_ firstName:String? ,_ lastName:String?,_ imageIcon:UIImageView
    ){
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
    
    @objc func getBack(sender: UIBarButtonItem) {
        self.dismiss(animated: false)
    }
}
