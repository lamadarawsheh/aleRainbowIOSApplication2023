//
//  AudioCallViewController.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 27/04/2023.
//

import UIKit
import Rainbow
class AudioCallViewController: UIViewController {

    @IBOutlet weak var hangUpButton: UIButton!
    @IBOutlet weak var smallIcon: UIImageView!
    @IBOutlet weak var bigIcon: UIImageView!
    var currentCall:RTCCall? = nil {
        didSet{
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func hangUpButtonTapped(_ sender: Any) {
        if let currentCall = currentCall {
            ServicesManager.sharedInstance().rtcService.hangupCall(currentCall)
            print("hangggup")
            self.dismiss(animated: true)
        }
    }
}
