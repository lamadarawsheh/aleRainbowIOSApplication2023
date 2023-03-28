//
//  ViewController.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 16/03/2023.
//

import Rainbow
import MBProgressHUD
class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        if ServicesManager.sharedInstance().myUser.isInitialized{
            let tabbarViewController  = self.storyboard?.instantiateViewController(identifier: "tabbarView") as!   UITabBarController
            tabbarViewController.modalPresentationStyle = .fullScreen
            self.present(tabbarViewController, animated: false, completion: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(didLogin(notification:)), name: NSNotification.Name(kLoginManagerDidLoginSucceeded), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failedToLogin(notification: )), name: NSNotification.Name(kLoginManagerDidFailedToAuthenticate), object: nil)
        setImage()
        emailTextField.returnKeyType = UIReturnKeyType.next
        passwordTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.delegate = self
        passwordTextField.delegate = self
        super.viewDidLoad()
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        switchBasedNextTextField(textField)
        return true
    }
    func switchBasedNextTextField(_ textField: UITextField){
        switch textField {
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            view.endEditing(true)
            
        default:
            self.emailTextField.resignFirstResponder()
        }
    }
    
    
    @objc func keyboardDidShow(notification: Notification) {
        let activeField = view
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: view.frame.origin.y + 90 , right: 0.0)
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
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
    }
    
    @objc func didLogin(notification: NSNotification) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            let loginViewController  = self.storyboard?.instantiateViewController(identifier: "tabbarView") as!   UITabBarController
            loginViewController.modalPresentationStyle = .fullScreen
            self.present(loginViewController, animated: false)
        }
        
    }
    
    @objc func failedToLogin(notification: NSNotification ) {
        DispatchQueue.main.async { [self] in
            var message = "Failed to Login"
            if let error = notification.object as? NSError{
                message  = error.localizedDescription
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
            showBasicAlert(on: self, with: "Error", message: message)
        }
    }
    func setImage(){
        self.logo.layer.borderWidth = 0.5
        self.logo.layer.masksToBounds = false
        logo.layer.cornerRadius = logo.frame.size.width/2
        self.logo.clipsToBounds = true
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
