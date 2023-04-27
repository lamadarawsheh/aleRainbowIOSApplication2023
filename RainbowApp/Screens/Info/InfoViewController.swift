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
    var currentCall:RTCCall? = nil {
        didSet{
          
              
        }
    }
    @IBAction func audioTapped(_ sender: Any) {
        currentCall = ServicesManager.sharedInstance().rtcService.beginNewOutgoingCall(with: contact!, withFeatures: RTCCallFeatureFlags.audio)
      

    }
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(didCallSuccess(notification:)), name: NSNotification.Name(kTelephonyServiceDidAddCall), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didCallSuccess(notification:)), name: NSNotification.Name(kTelephonyServiceDidUpdateCall), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didremnovecall(notification:)), name: NSNotification.Name(kTelephonyServiceDidRemoveCall), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didCallSuccess(notification:)), name: NSNotification.Name(kRTCServiceDidAllowMicrophone), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didCallSuccess(notification:)), name: NSNotification.Name(kRTCServiceDidRefuseMicrophone), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didCallSuccess(notification:)), name: NSNotification.Name(kRTCServiceDidAddLocalVideoTrack), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didCallSuccess(notification:)), name: NSNotification.Name(kRTCServiceDidAddCaptureSession), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didCallSuccess(notification:)), name: NSNotification.Name(kRTCServiceCallStats), object: nil)
        
        ImageHelper().configureImageView(smallIcon)
        super.viewDidLoad()
        nameLabel.text = contact?.displayName
        companyLabel.text = contact?.companyName
        title = (contact?.firstName ?? "User") + "'s information"
        smallIcon.image = ImageHelper().getImage(contact?.photoData,contact?.firstName ,contact?.lastName)
        bigIcon.image = ImageHelper().getImage(contact?.photoData,contact?.firstName ,contact?.lastName)
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
    @objc func didCallSuccess(notification: NSNotification) {
        if let call = notification.object as? RTCCall{
             currentCall = call
            print("callsuccessssss")
         }
        DispatchQueue.main.async{ [self] in
            let audioCallView  = self.storyboard?.instantiateViewController(identifier: "AudiocallView") as!   AudioCallViewController
            audioCallView.view.backgroundColor = .white
            ImageHelper().configureImageView(audioCallView.smallIcon)
            audioCallView.smallIcon.image = ImageHelper().getImage(contact?.photoData,contact?.firstName ,contact?.lastName)
            audioCallView.bigIcon.image = ImageHelper().getImage(contact?.photoData,contact?.firstName ,contact?.lastName)
            ImageHelper().blurEffect(audioCallView.bigIcon)
            audioCallView.currentCall = currentCall
            self.navigationController?.present(audioCallView, animated: true)
        
        }
    }
    @objc func didremnovecall(notification: NSNotification) {
        DispatchQueue.main.async{ [self] in
            print("enddddddddddd")
            print(type(of: notification.object))

        }
    }
}
