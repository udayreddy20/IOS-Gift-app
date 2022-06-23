//
//  MovieListVC.swift

import UIKit

class MovieListVC: UIViewController {

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwMainback: UIView!
    @IBOutlet weak var sbBar: UISearchBar!
    @IBOutlet weak var lblTitle: UILabel!
    
    var pendingItem: DispatchWorkItem?
    var pendingRequest: DispatchWorkItem?
    var gerneData : GerneModel!
    var array = [MovieModel]()
    var arrData = [MovieModel]()
    var isFav : Bool = true
    
    
    func setUpView(){
        if gerneData != nil {
            self.lblTitle.text = gerneData.name.description
            self.getData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sbBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        self.navigationController?.navigationBar.isHidden = true
    }
}


extension MovieListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.btnBook.isUserInteractionEnabled = false
        let data = self.arrData[indexPath.row]
        cell.configCell(data: data)
        cell.imgFav.addAction(for: .touchUpInside) {
            self.isFav = false
            if let email = GFunction.user.email {
                self.checkAddToFav(data: data, email: email)
            }
            Alert.shared.showAlert(message: "Movie has been added as favourite !!!"){ (true) in
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: CheckDatesVC.self) {
                vc.movieData = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.vwCell.isUserInteractionEnabled = true
        cell.vwCell.addGestureRecognizer(tap)
        cell.selectionStyle = .none
        return cell
    }
}

class MovieCell : UITableViewCell {
    @IBOutlet weak var lblTitle: GradientLabel!
    @IBOutlet weak var lblStar: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var imgFav: UIButton!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var vwCell: UIView!
    
    
    override func awakeFromNib() {
        self.vwCell.layer.cornerRadius = 20
        self.imgMovie.layer.cornerRadius = 20
        self.btnBook.layer.cornerRadius = 5
        
        self.lblTitle.gradientColors = [
            UIColor.hexStringToUIColor(hex: "#6043F5").cgColor,
            UIColor.hexStringToUIColor(hex: "#836EF1").cgColor
        ]
    }
    
    func configCell(data: MovieModel){
        self.lblTitle.text = data.name
        self.lblStar.text = data.rate
        self.imgMovie.setImgWebUrl(url: data.imagePath, isIndicator: true)
    }
}


//MARK:- API
extension MovieListVC {
    func getData(){
        _ = AppDelegate.shared.db.collection(eMovieList).whereField(eGerneName, isEqualTo: self.gerneData.name).addSnapshotListener{ querySnapshot, error in
            
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
                self.arrData = self.array
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
    
    func addToFav(data: MovieModel,email:String){
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(eFavourite).addDocument(data:
            [
                eName: data.name,
                ePrice: data.price,
                eEmail: email,
                eMovieID: data.docID,
                eReview: data.review,
                eRate: data.rate
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Movie has been added as favourite !!!"){ (true) in
                    UIApplication.shared.setTab()
                }
            }
        }
    }
    
    func checkAddToFav(data: MovieModel, email:String) {
        _ = AppDelegate.shared.db.collection(eFavourite).whereField(eEmail, isEqualTo: email).whereField(eMovieID, isEqualTo: data.docID).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count == 0 {
                self.isFav = true
                self.addToFav(data: data, email: email)
            }else{
                if !self.isFav {
                    Alert.shared.showAlert(message: "Item has been already existing into Favourite!!!", completion: nil)
                }
                
            }
        }
    }
}


//MARK:- UISearchBarDelegate Delegate methods :-
extension MovieListVC : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.pendingRequest?.cancel()
        
        guard searchBar.text != nil else {
            return
        }
        
        if(searchText.count == 0 || (searchText == " ")){
            self.arrData = self.array
            self.tblList.reloadData()
            return
        }
        
        //self.isTextEdit = true
        
        self.pendingRequest = DispatchWorkItem{ [weak self] in
            
            guard let self = self else { return }
            
            self.arrData = self.array.filter({$0.name.localizedStandardContains(searchText)})
            self.tblList.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: self.pendingRequest!)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.arrData = self.array.filter({$0.name.localizedStandardContains(searchBar.text!)})
        self.tblList.reloadData()
        self.sbBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.arrData = self.array
        self.sbBar.resignFirstResponder()
    }
}
