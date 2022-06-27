//
//  SuccessVC.swift
//  FlowerApp


import UIKit

class SuccessVC: UIViewController {

    @IBAction func btnSuccessClick(_ sender: UIButton) {
        UIApplication.shared.setTab()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }


}
