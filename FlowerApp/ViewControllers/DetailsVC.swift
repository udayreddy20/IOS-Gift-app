//
//  DetailsVC.swift
//  FlowerApp


import UIKit

class DetailsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var imgData: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnAddToFav: BlueThemeButton!
    @IBOutlet weak var btnOrder: BlueThemeButton!
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    
    //MARK:- Action Methods
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnOrder {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SuccessVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnAddToFav {
            Alert.shared.showAlert(message: "Bouquet has been added as Favourite", completion: nil)
        }
    }
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgData.layer.cornerRadius = 15.0
        // Do any additional setup after loading the view.
    }
}
