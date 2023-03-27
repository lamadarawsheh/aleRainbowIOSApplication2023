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
            if contacts.count == 0
            {
                noContactsLabel.isHidden = false
            }
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        
        configureItems()
        
        setContacts()
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout(notification:)), name: NSNotification.Name(kLoginManagerDidLogoutSucceeded), object: nil)
        
        let nib = UINib(nibName: "ContactsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ContactsTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        
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
    
    func setContacts (){
        self.contacts =  (ServicesManager.sharedInstance()?.contactsManagerService.myNetworkContacts)!
        self.contacts = filter(contacts: self.contacts)
        print("jhjbb")
        print(contacts.count)
        self.contacts = contacts.sorted(by: {$0.displayName.lowercased() < $1.displayName.lowercased()})
        
        
        
        
        
    }
    func filter(contacts: [Contact]) -> [Contact] {
        
        return contacts.filter { (contact) -> Bool in
            return isContactPartOfTheNetwork(contact: contact)
        }
    }
    
    func isContactPartOfTheNetwork(contact:Contact) -> Bool {
        
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
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    func viewInfo(_ contact:Contact) {
        let infoNavViewController  = self.storyboard?.instantiateViewController(identifier: "userInfo") as!   UINavigationController
        
        let infoViewController  =  infoNavViewController.topViewController  as!   InfoViewController
        infoViewController.contact = contact
        
        infoNavViewController.modalPresentationStyle = .fullScreen
        self.present(infoNavViewController, animated: false)
        
    }
    
}
protocol ViewActionDelegate {
    
    func viewInfo(_ contact:Contact)
}
