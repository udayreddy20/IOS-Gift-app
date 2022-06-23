//
//  AddMovieVC.swift


import UIKit
import Photos
import FirebaseStorage
import OpalImagePicker

class AddMovieVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtGerne: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtReview: UITextField!
    @IBOutlet weak var txtRates: UITextField!
    @IBOutlet weak var btnAdd: BlueThemeButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    var picker = UIPickerView()
    var array = [GerneModel]()
    var data : GerneModel!
    var dataMovie : MovieModel!
    var storageRef = StorageReference()
    var imgPicker = UIImagePickerController()
    var imageData = UIImage()
    var imgPicker1 = OpalImagePickerController()
    var isImageSelected = false
    var imageURL = ""
    
    @IBAction func btnAddClick(_ sender: UIButton) {
        if sender == btnAdd {
            let error = self.validation()
            if error == "" {
                if dataMovie != nil {
                    dataMovie.name = self.txtname.text ?? ""
                    dataMovie.rate = self.txtRates.text ?? ""
                    dataMovie.price = self.txtPrice.text ?? ""
                    dataMovie.gerneID = self.data.docId
                    dataMovie.gerneName = self.data.name
                    dataMovie.review = self.txtReview.text ?? ""
                    self.updateMovie(data: dataMovie)
                }else{
                    self.addMovie(name: self.txtname.text ?? "", description: self.txtRates.text ?? "", price: self.txtPrice.text ?? "",data: self.data,review: self.txtReview.text ?? "")
                }
                
            }else {
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }else if sender == btnDelete {
            self.removeMovie(data: self.dataMovie)
        }
    }
    
    func validation() -> String {
        if self.txtname.text?.trim() == ""{
            return "Please enter name"
        }else if self.txtGerne.text?.trim() == "" {
            return "Please select gerne"
        }else if self.txtRates.text?.trim() == "" {
            return "Please enter rates"
        }else if self.txtReview.text?.trim() == "" {
            return "Please enter review"
        }else if self.txtPrice.text?.trim() == "" {
            return "Please enter price"
        }else if !self.isImageSelected {
            return "Please select Image"
        }
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        self.txtGerne.inputView = picker
        self.btnDelete.isHidden = true
        self.imgPicker.delegate = self
        self.imgPicker.isEditing = true
        if dataMovie != nil {
            self.btnDelete.isHidden = false
            self.txtname.text = dataMovie.name.description
            self.txtPrice.text = dataMovie.price.description
            self.txtGerne.text = dataMovie.gerneName.description
            self.txtRates.text = dataMovie.rate.description
            self.txtReview.text = dataMovie.review.description
            self.imageURL = dataMovie.imagePath
            self.imgView.setImgWebUrl(url: dataMovie.imagePath, isIndicator: true)
            self.btnAdd.setTitle("Edit", for: .normal)
            self.isImageSelected = true
        }
        
        let tap = UITapGestureRecognizer()
        tap.addAction {
            self.openPicker()
        }
        self.imgView.isUserInteractionEnabled = true
        self.imgView.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension AddMovieVC {
    func openPicker(){
        
        
        let actionSheet = UIAlertController(title: nil, message: "Select Image", preferredStyle: .actionSheet)
        
        let cameraPhoto = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return Alert.shared.showAlert(message: "Camera not Found", completion: nil)
            }
            GFunction.shared.isGiveCameraPermissionAlert(self) { (isGiven) in
                if isGiven {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.imgPicker.mediaTypes = ["public.image"]
                        self.imgPicker.sourceType = .camera
                        self.imgPicker.cameraDevice = .rear
                        self.imgPicker.allowsEditing = true
                        self.imgPicker.delegate = self
                        self.present(self.imgPicker, animated: true)
                    }
                }
            }
        })
        
        let PhotoLibrary = UIAlertAction(title: "Gallary", style: .default, handler:
                                            { [self]
            (alert: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let photos = PHPhotoLibrary.authorizationStatus()
                if photos == .denied || photos == .notDetermined {
                    PHPhotoLibrary.requestAuthorization({status in
                        if status == .authorized {
                            DispatchQueue.main.async {
                                self.imgPicker1 = OpalImagePickerController()
                                self.imgPicker1.imagePickerDelegate = self
                                self.imgPicker1.isEditing = true
                                present(self.imgPicker1, animated: true, completion: nil)
                            }
                        }
                    })
                }else if photos == .authorized {
                    DispatchQueue.main.async {
                        self.imgPicker1 = OpalImagePickerController()
                        self.imgPicker1.imagePickerDelegate = self
                        self.imgPicker1.isEditing = true
                        present(self.imgPicker1, animated: true, completion: nil)
                    }
                    
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
            
        })
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        actionSheet.addAction(cameraPhoto)
        actionSheet.addAction(PhotoLibrary)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func addMovie(name: String, description:String,price: String,data: GerneModel,review:String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(eMovieList).addDocument(data:
            [
              eName: name,
              eRates : description,
              eGerneID: data.docId,
              eGerneName: data.name,
              eReview: review,
              ePrice: price,
              eImagePath: self.imageURL
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Your Movie has been added Successfully !!!") { (true) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func getData() {
        _ = AppDelegate.shared.db.collection(eGerne).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[eName] as? String, let image: String = data1[eImagePath] as? String {
                        self.array.append(GerneModel(docId: data.documentID, name: name, image: image))
                    }
                }
                print("Gerne Data Count : \(self.array.count)")
                self.data = self.array[0]
                self.picker.delegate = self
                self.picker.dataSource = self
                self.picker.reloadAllComponents()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
    
    func updateMovie(data: MovieModel) {
        let ref = AppDelegate.shared.db.collection(eMovieList).document(data.docID)
        ref.updateData([
            eName: data.name,
            eRates : data.rate,
            eGerneID: data.gerneID,
            eGerneName: data.name,
            eReview: data.review,
            ePrice: data.price,
            eImagePath: self.imageURL
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                Alert.shared.showAlert(message: "Your Movie has been updated successfully !!!") { (true) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func removeMovie(data: MovieModel){
        let ref = AppDelegate.shared.db.collection(eMovieList).document(data.docID)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully deleted")
                Alert.shared.showAlert(message: "Your Movie has been deleted successfully !!!") { (true) in
                    UIApplication.shared.setAdmin()
                }
            }
        }
    }
}


extension AddMovieVC: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.array[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.data = self.array[row]
        self.txtGerne.text = self.array[row].name
//        self.data = self.array[row]
    }
    
    func uploadImagePic(img1 :UIImage){
        let data = img1.jpegData(compressionQuality: 0.8)! as NSData
        // set upload path
        let imagePath = GFunction.shared.UTCToDate(date: Date())
        let filePath = "Movie/\(imagePath)" // path where you wanted to store img in storage
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference(withPath: filePath)
        storageRef.putData(data as Data, metadata: metaData) { (metaData, error) in
            if let error = error {
                return
            }
            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                self.isImageSelected = true
                self.imageURL = url?.absoluteString ?? ""
                print(url?.absoluteString) // <- Download URL
                self.imgView.setImgWebUrl(url: self.imageURL, isIndicator: true)
            })
        }
    }
}

//MARK:- UIImagePickerController Delegate Methods
extension AddMovieVC: UIImagePickerControllerDelegate, OpalImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        if let image = info[.editedImage] as? UIImage {
            uploadImagePic(img1: image)
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        do { picker.dismiss(animated: true) }
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]){
        for image in assets {
            if let image = getAssetThumbnail(asset: image) as? UIImage {
                uploadImagePic(img1: image)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: (asset.pixelWidth), height: ( asset.pixelHeight)), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController){
        dismiss(animated: true, completion: nil)
    }
}
