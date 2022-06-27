//
//  CustomVC.swift
//  FlowerApp


import UIKit

class CustomVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblList: SelfSizedTableView!
    @IBOutlet weak var btnIsCover: UIButton!
    @IBOutlet weak var btnISNotes: UIButton!
    @IBOutlet weak var btnPlaceOrder: BlueThemeButton!
    @IBOutlet weak var txtNotes: ThemeTextField!
    @IBOutlet weak var vwNotes: UIView!
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    
    //MARK:- Action Methods
    @IBAction func btnIsSelectClick(_ sender:  UIButton){
        if sender == self.btnIsCover {
            self.btnIsCover.isSelected.toggle()
        }else if sender == self.btnISNotes {
            self.btnISNotes.isSelected.toggle()
            self.vwNotes.isHidden = !self.btnISNotes.isSelected
        }else if sender == btnPlaceOrder {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SuccessVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblList.delegate = self
        self.tblList.dataSource = self
        self.vwNotes.isHidden = true
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


extension CustomVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.btnSelect.addAction(for: .touchUpInside) {
            cell.btnSelect.isSelected.toggle()
        }
        return cell
    }
}


class CustomCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var imgData: UIImageView!
    @IBOutlet weak var vwMain: UIView!
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwMain.layer.cornerRadius = 5.0
        self.vwMain.shadow()
        self.vwMain.backgroundColor = .white
    }
}
