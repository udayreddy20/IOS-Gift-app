//
//  FavouriteVC.swift


import UIKit

class FavouriteVC: UIViewController {

    @IBOutlet weak var tblList: UITableView!
    var array = [MovieModel]()
    var isFav : Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let email = GFunction.user.email {
            self.getFavData(email: email)
        }
    }
}


extension FavouriteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.btnBook.isUserInteractionEnabled = false
        let data = self.array[indexPath.row]
        cell.configCell(data: data)
//        cell.imgFav.isSelected = true
        cell.imgFav.addAction(for: .touchUpInside) {
            self.isFav = false
            if let email = GFunction.user.email {
                self.removeFromFav(data: data, email: email)
            }
        }
        
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: CheckDatesVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.vwCell.isUserInteractionEnabled = true
        cell.vwCell.addGestureRecognizer(tap)
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: CheckDatesVC.self) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK:- API
extension  FavouriteVC {
    func getFavData(email:String){
        _ = AppDelegate.shared.db.collection(eFavourite).whereField(eEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[eName] as? String, let rate: String = data1[eRate] as? String, let review :String = data1[eReview] as? String, let categoryID:String = data1[eMovieID] as? String, let price:String = data1[ePrice] as? String /*, let imagePath: String = data1[eImagePath] as? String */ {
                        print("Data Count : \(self.array.count)")
                        self.array.append(MovieModel(docID: data.documentID, name: name, rate: rate, gerneID: categoryID, gerneName: "", review: review,price: price, imagePath: " "))
                    }
                }
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
    
    func removeFromFav(data: MovieModel,email:String){
        let ref = AppDelegate.shared.db.collection(eFavourite).document(data.docID)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully deleted")
                UIApplication.shared.setTab()
            }
        }
    }
}

