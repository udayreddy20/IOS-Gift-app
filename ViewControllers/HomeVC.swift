//
//  HomeVC.swift

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var colImageList: UICollectionView!
    @IBOutlet weak var colGernsList: UICollectionView!
    
    var array = [TrendingModel]()
    var array1 = [GerneModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
        self.getGerneData()
        self.navigationController?.navigationBar.isHidden = true
    }

}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout & UINavigationControllerDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colImageList {
            return self.array.count
        }
        return self.array1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colImageList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCell", for: indexPath) as! TrendingCell
            cell.configCell(data: self.array[indexPath.row])
            cell.vwMovie.layer.cornerRadius = 10
            cell.vwMovie.clipsToBounds = true
            return cell
        }
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "GernesCell", for: indexPath) as! GernesCell
        item.vwCell.tag = (indexPath.section * 1000) + indexPath.row
        item.vwCell.clipsToBounds = true
        let data = self.array1[indexPath.row]
        item.configCell(data: data)
        item.vwCell.layer.cornerRadius = 8.0
        item.vwCell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.15).cgColor
        item.vwCell.layer.borderWidth = 1.0
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: MovieListVC.self) {
                vc.gerneData = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        item.consWidth.constant = ((150/375) * UIScreen.main.bounds.width)
        item.vwCell.addGestureRecognizer(tap)
        return item
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == colImageList {
            return CGSize(width: UIScreen.main.bounds.width - 40, height: ((200/812) * UIScreen.main.bounds.height))
        }
        return CGSize(width: ((UIScreen.main.bounds.width - 50) / 2), height: ((122/812) * self.view.frame.height))
    }

}



class TrendingCell: UICollectionViewCell {
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var vwMovie: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwMovie.layer.cornerRadius = 10.0
        self.imgMovie.layer.cornerRadius = 10.0
        self.imgMovie.backgroundColor = .lightGray
    }
    
    func configCell(data: TrendingModel){
        self.imgMovie.setImgWebUrl(url: data.image, isIndicator: true)
    }
}

class GernesCell: UICollectionViewCell {
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var consWidth: NSLayoutConstraint!
    
    
    func configCell(data: GerneModel) {
        self.lblTitle.text = data.name.description
        self.imgLogo.setImgWebUrl(url: data.image, isIndicator: true)
    }
}



//MARK:- API
extension HomeVC {
    func getData(){
        _ = AppDelegate.shared.db.collection(eTrending).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[eName] as? String, let image: String = data1[eImage] as? String {
                        self.array.append(TrendingModel(docID: data.documentID, name: name, image: image))
                    }
                }
                print("Trending Data Count : \(self.array.count)")
                self.colImageList.delegate = self
                self.colImageList.dataSource = self
                self.colImageList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
    
    func getGerneData(){
        _ = AppDelegate.shared.db.collection(eGerne).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array1.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[eName] as? String, let image: String = data1[eImagePath] as? String {
                        self.array1.append(GerneModel(docId: data.documentID, name: name, image: image))
                    }
                }
                print("Trending Data Count : \(self.array.count)")
                self.colGernsList.delegate = self
                self.colGernsList.dataSource = self
                self.colGernsList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
}

