//
//  ViewController.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 16/03/2023.
//

import Rainbow
class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    @objc func keyboardDidShow(notification: Notification) {
        let activeField = view
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: view.frame.origin.y + 200 , right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        let activeRect = activeField!.convert(activeField!.bounds, to: scrollView)
        scrollView.scrollRectToVisible(activeRect, animated: true)
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -90, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    func showBasicAlert(on vc: UIViewController, with title: String, message: String){
        
        let alert =  UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default)
        
        alert.addAction(okAction)
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        ServicesManager.sharedInstance()?.loginManager.setUsername(emailTextField.text, andPassword: passwordTextField.text)
        ServicesManager.sharedInstance()?.loginManager.connect()
        NotificationCenter.default.addObserver(self, selector: #selector(didLogin(notification:)), name: NSNotification.Name(kLoginManagerDidLoginSucceeded), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failedToLogin), name: NSNotification.Name(kLoginManagerDidFailedToAuthenticate), object: nil)
        
    }
    
    @objc func didLogin(notification: NSNotification) {
        DispatchQueue.main.async {
            let vc  = self.storyboard?.instantiateViewController(identifier: "tabbarView") as!   UITabBarController
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(vc, animated: false)
        }
        
    }
    
    
    @objc func failedToLogin() {
        
        DispatchQueue.main.async { [self] in
            showBasicAlert(on: self, with: "Warning", message: "your email or password may be wrong check again!")
            
            
        }
    }
    
    
}

