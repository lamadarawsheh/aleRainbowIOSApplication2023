//
//  ConversationsViewController.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 20/03/2023.
//

import UIKit
import Rainbow
class ConversationsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var conversations: [Conversation] = [Conversation]() {
        didSet {
        }
    }
    var data:Data = Data () {
        didSet {
        }
    }
    var contacts:[Contact] = [Contact](){
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishLoading(notification:)), name: NSNotification.Name(kConversationsManagerDidEndLoadingConversations), object: nil)
        tableView.register(UITableViewCell.self,forCellReuseIdentifier:"cell")
        
        tableView.dataSource = self
        tableView.delegate = self
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
        
        logoutButton.addTarget(self, action: #selector(goToLogin(sender: )), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        
    }
    
    @objc func didFinishLoading(notification: NSNotification) {
        DispatchQueue.main.async {
            self.conversations =  ServicesManager.sharedInstance().conversationsManagerService.conversations
            self.contacts =  (ServicesManager.sharedInstance()?.contactsManagerService.myNetworkContacts)!
            
        }
        
    }
    
    @objc func goToLogin(sender: UIBarButtonItem) {
        let loginViewController  = self.storyboard?.instantiateViewController(identifier: "Login") as!   UINavigationController
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: false, completion: nil)
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
    func getuserAvatar(_ rainbowID:String){
        
        let contact = contacts.first(where: {$0.rainbowID == rainbowID})
        
        if contact != nil
        {
            if contact?.photoData != nil
            {
                self.data = (contact?.photoData)!
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        
        return self.conversations.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)as!
        CustomTableViewCell
        
        cell.nameLabel.text = conversations[indexPath.row].peer?.displayName
        
        cell.messageLabel.text = conversations[indexPath.row].lastMessage?.body
        cell.dateLabel.text  = String ((conversations[indexPath.row].lastMessage?.date.formatted(date: .numeric, time: .shortened).split(separator: ",").last)! )
        
        getuserAvatar((conversations[indexPath.row].peer?.rainbowID)!)
        cell.setImage(self.data)
        
        return cell
        
    }
    
    
}
