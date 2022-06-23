//
//  LoginVC.swift


import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: BlueThemeButton!
    @IBOutlet weak var lblSignUp: UILabel!
    
    var flag: Bool = true
    var socialData: SocialLoginDataModel!
    
    func validation() -> String {
        if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }else if (self.txtPassword.text?.trim().count)! < 8 {
            return "Please enter 8 character for password"
        }
        return ""
    }
    
    func setUpView(){
        self.applyStyle()
        
        self.lblSignUp.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.lblSignUp.addGestureRecognizer(tap)
    }
    
    func applyStyle(){
        self.lblWelcome.font = UIFont(name: "bold", size: 16.0)
        self.lblWelcome.textColor = UIColor.hexStringToUIColor(hex: "#9D9998")
        self.txtPassword.isSecureTextEntry = true
        self.txtEmail.text = "test@grr.la"
        self.txtPassword.text = "Test@1234"
        if socialData != nil {
            self.txtEmail.text = socialData.email.description
            self.txtEmail.isUserInteractionEnabled = false
        }
    }
    
    //MARK:- Action Method
    @IBAction func btnLoginClick(_ sender: UIButton) {
        self.flag = false
        let error = self.validation()
        if error == "" {
            if txtEmail.text?.trim() == "Admin@gmail.com" && txtPassword.text?.trim() == "Admin@1234" {
                UIApplication.shared.setAdmin()
            }else{
                self.loginUser(email: self.txtEmail.text?.trim() ?? "", password: self.txtPassword.text?.trim() ?? "")
            }
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }
}


//MARK:- Extension for Login Function
extension LoginVC {
    
    
    func loginUser(email:String,password:String) {
        _ = AppDelegate.shared.db.collection(eUser).whereField(eEmail, isEqualTo: email).whereField(ePassword, isEqualTo: password).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                let docId = snapshot.documents[0].documentID
                if let address : String = data1[eAddress] as? String, let name: String = data1[eName] as? String, let phone: String = data1[ePhone] as? String, let email: String = data1[eEmail] as? String, let password: String = data1[ePassword] as? String {
                    GFunction.user = UserModel(docId: docId, name: name, email: email, phone: phone, password: password, address: address)
                }
                GFunction.shared.firebaseRegister(data: email)
//                if let vc = UIStoryboard.main.instantiateViewController(withClass: AddTheaterVC.self){
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
                UIApplication.shared.setTab()
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "Please check your credentials !!!", completion: nil)
                    self.flag = true
                }
            }
        }
        
    }
}
