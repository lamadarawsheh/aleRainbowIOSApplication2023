//
//  ContactsViewController.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 20/03/2023.
//

import UIKit
import Rainbow
import MBProgressHUD
class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,ViewActionDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noContactsLabel: UILabel!
    var contacts: [Contact] = [Contact]() {
        didSet {
            noContactsLabel.isHidden = !contacts.isEmpty
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        configureItems()
        setContacts()
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout(notification:)), name: NSNotification.Name(kLoginManagerDidLogoutSucceeded), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateContacts(notification:)), name: NSNotification.Name(kContactsManagerServiceDidUpdateContact), object: nil)
        let nib = UINib(nibName: "ContactsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ContactsTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        super.viewDidLoad()
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
    @objc func didUpdateContacts(notification: NSNotification) {
        DispatchQueue.main.async{ [self] in
            setContacts()
            self.tableView.reloadData()
        }
    }
    
    func setContacts (){
        guard let contacts = ServicesManager.sharedInstance()?.contactsManagerService.myNetworkContacts else {return}
        self.contacts = filter(contacts: contacts)
        self.contacts = contacts.sorted(by: {$0.lastName.lowercased() < $1.lastName.lowercased()})
    }
    
    func filter(contacts: [Contact]) -> [Contact] {
        return contacts.filter { (contact) -> Bool in
            guard let _:String = contact.rainbowID else {
                // Check that contact object is well formed
                return false
            }
            
            if contact.rainbowID == ServicesManager.sharedInstance()?.myUser.contact?.rainbowID {
                // Check that this is not the connected user
                return false
            }
            
            if(contact.isBot) {
                // Put to true if you want to keep bots
                return false
            }
            
            // Check that the user is really in the roster
            return contact.isInRoster
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat  = self.storyboard?.instantiateViewController(identifier: "chatView") as!   ChatViewController
        ServicesManager.sharedInstance().conversationsManagerService.startConversation(with: contacts[indexPath.row], withCompletionHandler: {_,_ in
            DispatchQueue.main.async { [self] in
                print("done")
                let conversations = ServicesManager.sharedInstance().conversationsManagerService.conversations
                chat.conversation = conversations?.first(where: {$0.peer == contacts[indexPath.row]})
                        self.navigationController?.pushViewController(chat, animated: true)
            }
        })

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell")as!
        ContactsTableViewCell
        cell.delegate = self
        cell.contact = contacts[indexPath.row]
        return cell
    }
    func viewContactInfo(_ contact:Contact) {
        let infoViewController  = self.storyboard?.instantiateViewController(identifier: "userInfoview") as!   InfoViewController
        infoViewController.contact = contact
        self.navigationController?.pushViewController(infoViewController, animated: true)
    }
}
protocol ViewActionDelegate {
    func viewContactInfo(_ contact:Contact)
}
