//
//  PaymentVC.swift

import UIKit

class PaymentVC: UIViewController {
    
    
    @IBOutlet weak var tblList: SelfSizedTableView!
    var array: [CardModel] = [CardModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let email = GFunction.user.email {
            self.getData(email: email)
        }
    }

}

extension PaymentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.configCell(data: self.array[indexPath.row])
        cell.vwCell.layer.cornerRadius = 10
        cell.btnSelected.isHidden = true
        if indexPath.row == 0 {
            cell.btnSelected.isHidden = false
        }
        cell.btnSelected.isHidden = true
        return cell
    }
}



class CardCell: UITableViewCell {
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var btnSelected: UIButton!
    
    var btnFavAct: (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.vwCell.backgroundColor = UIColor.hexStringToUIColor(hex: "#6043F5")
            self.btnSelected.layer.cornerRadius = 5
        }
    }

    func configCell(data: CardModel){
        let last = data.cardNumber.suffix(4)
        self.lblCardNumber.text = "•••• •••• •••• \(last)"
        self.lblCardName.text = data.name
    }
}


//MARK:- API
extension PaymentVC {
    func getData(email:String){
        _ = AppDelegate.shared.db.collection(eCardList).whereField(eEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[eCardName] as? String, let cardNumber: String = data1[eCardNumber] as? String, let email: String = data1[eEmail] as? String, let cvv: String = data1[eCVV] as? String, let expDate: String = data1[eCardExpiryDate] as? String {
                        self.array.append(CardModel(docId: data.documentID, name: name, cardNumber: cardNumber, expiryDate: expDate, cvv: cvv, email: email))
                    }
                }
                print("Card Data Count : \(self.array.count)")
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
}
