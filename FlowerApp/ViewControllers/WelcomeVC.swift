//
//  WelcomeVC.swift
//  FlowerApp


import UIKit

class WelcomeVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var btnSignUP: BlueThemeButton!
    @IBOutlet weak var btnSignGoogle: BlueThemeButton!
    @IBOutlet weak var btnSignFB: BlueThemeButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    
    //MARK:- Action Methods
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnSignUP {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUPVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnSignIn {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignInVC.self) {
                self.present(vc, animated: true, completion: nil)
            }
        }else{
            Alert.shared.showAlert(message: "Comming Soon", completion: nil)
        }
    }
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
