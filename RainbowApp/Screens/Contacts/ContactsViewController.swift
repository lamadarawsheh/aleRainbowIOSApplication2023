//
//  ContactsViewController.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 20/03/2023.
//

import UIKit
import Rainbow
class ContactsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout(notification:)), name: NSNotification.Name(kLoginManagerDidLogoutSucceeded), object: nil)
        // Do any additional setup after loading the view.
    }
    func configureItems(){
        let logoutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        
        
        logoutButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        let image = UIImage(systemName: "rectangle.portrait.and.arrow.forward")
        let cgImage =   UIImage(cgImage: (image?.cgImage)!, scale: 1.0, orientation: .upMirrored)
        logoutButton.setBackgroundImage(cgImage,for: .normal)
        
        logoutButton.addTarget(self, action: #selector(signout(sender: )), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        
    }
    
    
    @objc func signout(sender: UIBarButtonItem) {
        ServicesManager.sharedInstance()?.loginManager.disconnect()
        ServicesManager.sharedInstance()?.loginManager.resetAllCredentials()
        
    }
    
    @objc func didLogout(notification: NSNotification) {
        DispatchQueue.main.async{
            self.dismiss(animated: false)
        }
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
