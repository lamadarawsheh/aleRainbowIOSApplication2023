//
//  ConversationsViewController.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 20/03/2023.
//

import UIKit
import Rainbow
class ConversationsViewController: UIViewController {
    
    override func viewDidLoad() {
        
        configureItems()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func configureItems(){
        let logoutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        
        
        logoutButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        let image = UIImage(systemName: "rectangle.portrait.and.arrow.forward")
        let cgImage =   UIImage(cgImage: (image?.cgImage)!, scale: 1.0, orientation: .upMirrored)
        logoutButton.setBackgroundImage(cgImage,for: .normal)
        
        logoutButton.addTarget(self, action: #selector(goToEdit(sender: )), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        
    }
    @objc func goToEdit(sender: UIBarButtonItem) {
        self.parent?.navigationController?.popToRootViewController(animated: true)
        signout()
    }
    func signout() {
        ServicesManager.sharedInstance()?.loginManager.disconnect()
        ServicesManager.sharedInstance()?.loginManager.resetAllCredentials()
    }
    
    @objc func didLogout(notification: NSNotification) {
        NSLog("LOGOUT DONE ")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout(notification:)), name: NSNotification.Name(kLoginManagerDidLogoutSucceeded), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kLoginManagerDidLogoutSucceeded), object: nil)
    }
    
    
}
