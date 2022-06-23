//
//  AdminMovieListVC.swift


import UIKit

class AdminMovieListVC: UIViewController {

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwMainback: UIView!
    @IBOutlet weak var btnAddMovie: UIButton!
    
    
    var array = [MovieModel]()
    
    
    @IBAction func btnAddNewClick(_ sender: UIButton){
        if let vc = UIStoryboard.main.instantiateViewController(withClass: AddMovieVC.self) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.getData()
    }
}


extension AdminMovieListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.btnBook.isUserInteractionEnabled = false
        let data = self.array[indexPath.row]
        cell.configCell(data: data)
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: AddMovieVC.self) {
                vc.dataMovie = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.vwCell.isUserInteractionEnabled = true
        cell.vwCell.addGestureRecognizer(tap)
        cell.selectionStyle = .none
        return cell
    }
}



//MARK:- API
extension AdminMovieListVC {
    func getData(){
        _ = AppDelegate.shared.db.collection(eMovieList).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[eName] as? String, let rate: String = data1[eRates] as? String, let review :String = data1[eReview] as? String, let categoryName:String = data1[eGerneName] as? String, let categoryID:String = data1[eGerneID] as? String, let price:String = data1[ePrice] as? String, let imagePath: String = data1[eImagePath] as? String {
                        print("Data Count : \(self.array.count)")
                        self.array.append(MovieModel(docID: data.documentID, name: name, rate: rate, gerneID: categoryID, gerneName: categoryName, review: review,price: price, imagePath: imagePath))
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
}
