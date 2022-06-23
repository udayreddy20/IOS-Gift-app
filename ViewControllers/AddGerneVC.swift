//
//  AddGerneVC.swift


import UIKit
import Photos
import FirebaseStorage
import OpalImagePicker

class AddGerneVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var txtName : UITextField!
    @IBOutlet weak var btnAdd : UIButton!
    @IBOutlet weak var btnDelete : UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    var data: GerneModel!
    var storageRef = StorageReference()
    var imgPicker = UIImagePickerController()
    var imageData = UIImage()
    var imgPicker1 = OpalImagePickerController()
    var isImageSelected = false
    var imageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnDelete.isHidden = true
        if data != nil {
            self.txtName.text = data.name.description
            self.btnDelete.isHidden = false
            self.imgView.setImgWebUrl(url: data.image, isIndicator: true)
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
    
    @IBAction func btnAddClick(_ sender: UIButton) {
        if sender == btnAdd {
            let error = self.validation()
            if error == "" {
                if data != nil {
                    self.data.name = self.txtName.text ?? ""
                    self.updateGerne(data: self.data)
                }else{
                    self.addGerne(name: self.txtName.text ?? "")
                }
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }else if sender == btnDelete {
            self.removeGerne(data: self.data)
        }
    }
    
    func validation() -> String {
        if self.txtName.text?.trim() == ""{
            return "Please enter gerne name"
        }else if !self.isImageSelected {
            return "Please select Image"
        }
        return ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }

}


extension AddGerneVC {

    func uploadImagePic(img1 :UIImage){
        let data = img1.jpegData(compressionQuality: 0.8)! as NSData
        // set upload path
        let imagePath = GFunction.shared.UTCToDate(date: Date())
        let filePath = "Gerne/\(imagePath)" // path where you wanted to store img in storage
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
extension AddGerneVC: UIImagePickerControllerDelegate, OpalImagePickerControllerDelegate {
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
    
    func addGerne(name: String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(eGerne).addDocument(data:
            [
              eName: name,
              eImagePath: self.imageURL
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Your Gerne has been added Successfully !!!") { (true) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func updateGerne(data: GerneModel) {
        let ref = AppDelegate.shared.db.collection(eGerne).document(data.docId)
        ref.updateData([
            eName: data.name,
            eImagePath: self.imageURL
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                Alert.shared.showAlert(message: "Your Gerne has been updated successfully !!!") { (true) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func removeGerne(data: GerneModel){
        let ref = AppDelegate.shared.db.collection(eGerne).document(data.docId)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully deleted")
                Alert.shared.showAlert(message: "Your Gerne has been deleted successfully !!!") { (true) in
                    UIApplication.shared.setAdmin()
                }
            }
        }
    }
}
