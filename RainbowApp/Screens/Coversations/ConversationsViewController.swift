//
//  ConversationsViewController.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 20/03/2023.
//

import UIKit
import Rainbow
import MBProgressHUD
class ConversationsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var noConversationsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var conversations: [Conversation] = [Conversation]() {
        didSet {
            if conversations.count == 0
            {
                noConversationsLabel.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishLoading(notification:)), name: NSNotification.Name(kConversationsManagerDidEndLoadingConversations), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout(notification:)), name: NSNotification.Name(kLoginManagerDidLogoutSucceeded), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishLoading(notification:)), name: NSNotification.Name(kConversationsManagerDidAddConversation), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishLoading(notification:)), name: NSNotification.Name(kConversationsManagerDidRemoveConversation), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishLoading(notification:)), name: NSNotification.Name(kConversationsManagerDidUpdateConversation), object: nil)
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        
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
        
        logoutButton.addTarget(self, action: #selector(signout(sender: )), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        
    }
    
    @objc func didFinishLoading(notification: NSNotification) {
        DispatchQueue.main.async { [self] in
            self.conversations =  ServicesManager.sharedInstance().conversationsManagerService.conversations
            self.conversations = conversations.sorted(by: {($0.lastMessage?.timestamp) ?? Date() > ($1.lastMessage?.timestamp) ?? Date()})
            self.tableView.reloadData()
            
        }
    }
    
    @objc func signout(sender: UIBarButtonItem) {
        ServicesManager.sharedInstance()?.loginManager.disconnect()
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
    }
    
    @objc func didLogout(notification: NSNotification) {
        DispatchQueue.main.async{
            MBProgressHUD.hide(for: self.view, animated: true)
            ServicesManager.sharedInstance()?.loginManager.resetAllCredentials()
            self.dismiss(animated: false)
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        
        return self.conversations.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell")as!
        CustomTableViewCell
        
        cell.conversation = conversations[indexPath.row]
        return cell
        
    }
    
    
}
