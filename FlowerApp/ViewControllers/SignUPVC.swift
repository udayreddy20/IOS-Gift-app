//
//  SignUPVC.swift
//  FlowerApp


import UIKit

class SignUPVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var txtFirstName: ThemeTextField!
    @IBOutlet weak var txtLastName: ThemeTextField!
    @IBOutlet weak var txtEmail: ThemeTextField!
    @IBOutlet weak var txtCode: TextFieldPedding!
    @IBOutlet weak var txtMobile: ThemeTextField!
    @IBOutlet weak var txtCity: ThemeTextField!
    @IBOutlet weak var txtState: ThemeTextField!
    @IBOutlet weak var txtZipcode: ThemeTextField!
    @IBOutlet weak var txtPassword: ThemeTextField!
    @IBOutlet weak var txtConfirmPassword: ThemeTextField!
    @IBOutlet weak var lblAgreement: UILabel!
    @IBOutlet weak var btnSignUp: BlueThemeButton!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var btnSecure: UIButton!
    @IBOutlet weak var btnSecureText: UIButton!
    @IBOutlet weak var vwPhone: UIView!
    
    
    //MARK:- Class Variables
    var isCheckBoxSelected = Bool()
    let pickerCode = UIPickerView()
    let arrPickerCode = ["+1", "+7", "+40","+70","+89","+91","+97","+105","+296","+689","+986","+987"]
    
    
    //MARK:- Custom Methods
    private func setup() {
        let tapOnLbl = UITapGestureRecognizer(target: self, action: #selector(self.callLblTapped))
        tapOnLbl.numberOfTapsRequired = 1
        self.lblAgreement.addGestureRecognizer(tapOnLbl)
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtEmail.delegate = self
        self.txtCode.delegate = self
        self.txtMobile.delegate = self
        self.txtCity.delegate = self
        self.txtState.delegate = self
        self.txtZipcode.delegate = self
        self.txtPassword.delegate = self
        self.txtConfirmPassword.delegate = self
        self.txtCode.inputView = self.pickerCode
        self.pickerCode.delegate = self
        self.pickerCode.dataSource = self
        self.pickerCode.tag = 1
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.vwPhone.viewStyle()
    }
    
    private func applyStyle() {
        navigationItem.title = "SIGN UP"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        self.txtCode.leftView = paddingView
        self.txtCode.leftViewMode = .always
        self.txtCode.placeholder = "+1"
        
        self.btnSecure.setImage(UIImage(named: "closeEye"), for: .selected)
        self.btnSecure.setImage(UIImage(named: "openEye"), for: .normal)
        self.btnSecureText.setImage(UIImage(named: "closeEye"), for: .selected)
        self.btnSecureText.setImage(UIImage(named: "openEye"), for: .normal)
        self.btnCheckBox.setImage(UIImage(named: "plain"), for: .normal)
        self.btnCheckBox.setImage(UIImage(named: "tickMark"), for: .selected)
    
    }
    
    private func validation(fName: String, lName: String, email: String, code: String, mobile: String, city: String, state: String, zip: String, password: String, confirmPass: String, isCheckBoxSel: Bool) -> String {
        
        if fName.isEmpty {
            return STRING.errorEnterFName
            
        } else if lName.isEmpty {
            return STRING.errorEnterLName
            
        } else if email.isEmpty {
            return STRING.errorEmail
            
        } else if !Validation.isValidEmail(email) {
            return STRING.errorValidEmail
            
        } else if code.isEmpty {
            return STRING.errorCode
            
        } else if mobile.isEmpty {
            return STRING.errorMobile
            
        } else if !Validation.isValidPhoneNumber(mobile) {
            return STRING.errorValidMobile
            
        } else if city.isEmpty {
            return STRING.errorCity
            
        } else if state.isEmpty {
            return STRING.errorState
            
        } else if zip.isEmpty {
            return STRING.errorZipCode
            
        } else if password.isEmpty {
            return STRING.errorPassword
            
        } else if password.count < 8 {
            return STRING.errorPasswordCount
            
        } else if !Validation.isValidPassword(password) {
            return STRING.errorValidCreatePassword
            
        } else if confirmPass.isEmpty {
            return STRING.errorConfirmPassword
            
        } else if password != confirmPass {
            return STRING.errorPasswordMismatch
            
        } else if !isCheckBoxSel {
            return STRING.errorCheckBox
            
        } else {
            return ""
        }
    }
    
    //MARK:- Action Methods
    @IBAction func btnSecureTextapped(_ sender: UIButton) {
        
        if self.btnSecureText.isSelected {
            self.btnSecureText.isSelected = false
            self.txtPassword.isSecureTextEntry = false
        } else {
            self.btnSecureText.isSelected = true
            self.txtPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnSecureTapped(_ sender: UIButton) {
        
        if self.btnSecure.isSelected {
            self.btnSecure.isSelected = false
            self.txtConfirmPassword.isSecureTextEntry = false
        } else {
            self.btnSecure.isSelected = true
            self.txtConfirmPassword.isSecureTextEntry = true
        }
    }
    
    @objc func backButtonTapped() {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    @objc func callLblTapped() {
        if self.btnCheckBox.isSelected {
            self.btnCheckBox.isSelected = false
            self.isCheckBoxSelected = false
        } else {
            self.isCheckBoxSelected = true
            self.btnCheckBox.isSelected = true
        }
    }
    
    @IBAction func btnCheckBoxTapped(_ sender: UIButton) {
        if self.btnCheckBox.isSelected {
            self.btnCheckBox.isSelected = false
            self.isCheckBoxSelected = false
        } else {
            self.isCheckBoxSelected = true
            self.btnCheckBox.isSelected = true
        }
    }
    
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        let error = self.validation(fName: self.txtFirstName.text!.trim(), lName: self.txtLastName.text!.trim(), email: self.txtEmail.text!.trim(), code: self.txtCode.text!.trim(), mobile: self.txtMobile.text!.trim(), city: self.txtCity.text!.trim(), state: self.txtState.text!.trim(), zip: self.txtZipcode.text!.trim(), password: self.txtPassword.text!.trim(), confirmPass: self.txtConfirmPassword.text!.trim(), isCheckBoxSel: isCheckBoxSelected)
        
        if error.isEmpty {
            UIApplication.shared.setTab()
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.applyStyle()
        // Do any additional setup after loading the view.
    }

}


extension SignUPVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.txtFirstName:
            let characterSet = CharacterSet.init(charactersIn: string)
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ")
            return set.isSuperset(of: characterSet)
        case self.txtLastName:
            let characterSet = CharacterSet.init(charactersIn: string)
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ")
            return set.isSuperset(of: characterSet)
        case self.txtCode:
            let currentText = textField.text!
            let allowedCharacterSet = CharacterSet(charactersIn: "+0123456789")
            let characterSet = CharacterSet.init(charactersIn: string)
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 4 && allowedCharacterSet.isSuperset(of: characterSet)
        case self.txtMobile:
            let currentText = textField.text!
            let allowedCharacterSet = CharacterSet(charactersIn: "+0123456789")
            let characterSet = CharacterSet.init(charactersIn: string)
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 10 && allowedCharacterSet.isSuperset(of: characterSet)
        case self.txtCity:
            let characterSet = CharacterSet.init(charactersIn: string)
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ")
            return set.isSuperset(of: characterSet)
        case self.txtState:
            let characterSet = CharacterSet.init(charactersIn: string)
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ")
            return set.isSuperset(of: characterSet)
        case self.txtZipcode:
            let currentText = textField.text!
            let allowedCharacterSet = CharacterSet(charactersIn: "+0123456789")
            let characterSet = CharacterSet.init(charactersIn: string)
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 6 && allowedCharacterSet.isSuperset(of: characterSet)
        default:
            break
        }
        return true
    }
}

//MARK: - PICKERVIEW DELEGATE & DATASOURCE METHODS -

extension SignUPVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPickerCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPickerCode[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtCode.text = self.arrPickerCode[row]
        self.txtCode.resignFirstResponder()
    }
}
