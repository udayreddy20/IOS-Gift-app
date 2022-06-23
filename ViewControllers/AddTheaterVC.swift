//
//  AddTheaterVC.swift

import UIKit

class AddTheaterVC: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtSeatRow: UITextField!
    @IBOutlet weak var txtSeatColumn: UITextField!
    @IBOutlet weak var txtRating: UITextField!
    @IBOutlet weak var btnAdd: BlueThemeButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var data: TheaterModel!
    
    @IBAction func btnAddClick(_ sender: BlueThemeButton) {
        if data != nil {
            data.rate = self.txtRating.text ?? ""
            data.row = self.txtSeatRow.text ?? ""
            data.column = self.txtSeatColumn.text ?? ""
            data.location = self.txtLocation.text ?? ""
            data.name = self.txtName.text ?? ""
            self.updateTheater(data: data)
        }else{
            self.addTheater(name: self.txtName.text ?? "", location: self.txtLocation.text ?? "", row: self.txtSeatRow.text ?? "", column: self.txtSeatColumn.text ?? "", rating: self.txtRating.text ?? "")
        }
        
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        self.removeTheater(data: self.data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if data != nil {
            self.txtName.text = data.name.description
            self.txtRating.text = data.rate.description
            self.txtLocation.text = data.location.description
            self.txtSeatRow.text = data.row.description
            self.txtSeatColumn.text = data.column.description
            self.btnAdd.setTitle("Edit", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
}


extension AddTheaterVC {
    func addTheater(name: String, location:String,row: String,column: String,rating:String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(eTheaterList).addDocument(data:
            [
              eName: name,
              eAddress: location,
              eSeatRow: row,
              eSeatColumn: column,
              eReview: rating,
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Theater has been added Successfully !!!") { (true) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func updateTheater(data: TheaterModel) {
        let ref = AppDelegate.shared.db.collection(eTheaterList).document(data.docID)
        ref.updateData([
            eName: data.name,
            eAddress: data.location,
            eSeatRow: data.row,
            eSeatColumn: data.column,
            eReview: data.rate,
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                Alert.shared.showAlert(message: "Your Theater has been updated successfully !!!") { (true) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func removeTheater(data: TheaterModel){
        let ref = AppDelegate.shared.db.collection(eTheaterList).document(data.docID)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully deleted")
                Alert.shared.showAlert(message: "Your Theater has been deleted successfully !!!") { (true) in
                    UIApplication.shared.setAdmin()
                }
            }
        }
    }
}
