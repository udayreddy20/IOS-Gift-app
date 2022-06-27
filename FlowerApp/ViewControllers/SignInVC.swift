//
//  SignInVC.swift
//  FlowerApp


import UIKit

class SignInVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var lblSignIn: UILabel!
    @IBOutlet weak var lblSignDetail: UILabel!
    @IBOutlet weak var txtUsername: ThemeTextField!
    @IBOutlet weak var txtPassword: ThemeTextField!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblRememberMe: UILabel!
    @IBOutlet weak var btnSignIn: BlueThemeButton!
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var vwPassword: UIView!
    
    //MARK:- Class Variables
    var isCheckBoxSelected = Bool()
    
    //MARK:- Custom Methods
    
    func applyStyle() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(backButtonTapped))
       
        self.lblSignDetail.font =  UIFont(name: "regular", size: 16.0)
        self.lblSignDetail.textColor = .lightGray
        self.lblRememberMe.font = UIFont(name: "regular", size: 14.0)
        self.lblRememberMe.textColor = .lightGray
        self.btnEye.setImage(UIImage(named: "closeEye"), for: .selected)
        self.btnEye.setImage(UIImage(named: "openEye"), for: .normal)
        self.btnCheckBox.setImage(UIImage(named: "plain"), for: .normal)
        self.btnCheckBox.setImage(UIImage(named: "tickMark"), for: .selected)
    }
    
    
    func validation(email: String, password: String) -> String {
        
        if email.isEmpty {
            return STRING.errorEmail
        }else if !Validation.isValidEmail(email) {
            return STRING.errorValidEmail
        } else if password.isEmpty {
            return STRING.errorPassword
        } else if password.count < 8 {
                return STRING.errorPasswordCount
        } else if !Validation.isValidPassword(password) {
            return STRING.errorValidCreatePassword
        } else {
            return ""
        }
    }
    
    //MARK:- Action Methods
    @IBAction func btnCheckBoxTapped(_ sender: UIButton) {
        if self.btnCheckBox.isSelected {
            self.btnCheckBox.isSelected = false
        } else {
            self.isCheckBoxSelected = true
            self.btnCheckBox.isSelected = true
        }
    }
    
    @IBAction func btnEyeTapped(_ sender: UIButton) {
        if self.btnEye.isSelected {
            self.btnEye.isSelected = false
            self.txtPassword.isSecureTextEntry = false
        } else {
            self.btnEye.isSelected = true
            self.txtPassword.isSecureTextEntry = true
        }
    }
    
    
    @IBAction func btnSignInTapped(_ sender: UIButton) {
        let error = self.validation(email: self.txtUsername.text!,password: self.txtPassword.text!)
        
        if error.isEmpty {
            UIApplication.shared.setTab()
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //MARK:- ViewLifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
        // Do any additional setup after loading the view.
    }

}
