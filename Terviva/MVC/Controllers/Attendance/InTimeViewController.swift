//
//  InTimeViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 18/06/22.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Photos

class InTimeViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var pickedImageview: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var mainView: UIView!
    
    //MARK:- Variables
    var parentNavigation = UINavigationController()
    var imagePicker = UIImagePickerController()
    var pickedImageStr = String()
    var base64Image = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imagePicker.delegate = self
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.view.bounds
//        gradientLayer.colors = [SGColors.InOutColor?.cgColor, SGColors.OutIncolor?.cgColor]
//        self.mainView.layer.insertSublayer(gradientLayer, at: 0)
        self.commentTextField.placeholderColor(color: .white)
        self.commentTextField.placeholder = "Add Comment"
    }
    
    //MARK:- Pick Photo Button Tapped
    @IBAction func pickPhotoButtonTapped(_ sender: UIButton) {
        self.openCameraGalleryMethod()
    }
    
    //MARK:- Submit Button Tapped
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if self.base64Image != "" && self.commentTextField.text != "" {
         self.sendInTimeDeailsToServerMethod(pickedImage: self.base64Image, comment: self.commentTextField.text ?? "")
        } else {
            self.showAlert(title: projectName, message: fillRequiredFields)
        }
    }
    
    //MARK:- Send InTime Deails ToServer Method
    func sendInTimeDeailsToServerMethod(pickedImage: String, comment: String) {
        SGCommonMethods.SharedInstance.showLoader()
        let inTimeUrl = AppUrl.BaseUrl + MethodUrl.attendanceEntryUrl
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: Date())
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "id") as? String ?? ""
        let isd_code = userDefaults.object(forKey: "isd_code") as? String ?? ""
        let params = ["associate_id":id,"tl_id":isd_code,"outlet_id":"","attendance_type":"in","attendance_image":pickedImage,"latitude":latitudeStr,"longitude":longitudeStr,"distance":"8803914","attendance_date":currentDate,"reason":comment,"remarks":comment,"leave_type":""]
        NetworkingManager.instance.sendDetailsToServerMethod(parametersDict: params, imageDataDic: [:], baseUrl: inTimeUrl) { responseDic in
            print(responseDic)
            SGCommonMethods.SharedInstance.hideLoader()
            let status = responseDic["status"] as? Bool ?? false
            if status == true {
                DispatchQueue.main.async {
                    self.showAlertWithTitle(withTitle: projectName, andMessage: InTimeUpdate) { success in
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                             let sceneDelegate = windowScene.delegate as? SceneDelegate
                             else {
                                 return
                         }
                         sceneDelegate.navigateToHomeVC()
                    }
                }
            } else {
                let message = responseDic["message"] as? String ?? ""
                self.showAlert(title: projectName, message: message)
            }
        } failure: { error in
            SGCommonMethods.SharedInstance.hideLoader()
            self.showAlert(title: projectName, message: error)
        }
        
    }
    
}

//MARK:- UIIMagePicker Delegate Method
extension InTimeViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK:- Open Camera and Gallery Method
    func openCameraGalleryMethod()  {
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: projectName, message: nil, preferredStyle: .actionSheet)
            let takePhotoAction = UIAlertAction(title:  "Camera", style: .default) { (UIAlertAction) in
                self.cameraPresent()
                
                
            }
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(takePhotoAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Persent Camera
    func cameraPresent()  {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            openCamera()
        case .denied:
            self.showImagesAlertMessages(title: "allowCameraSettings")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted == true {
                    self.openCamera()
                }else {
                    self.showImagesAlertMessages(title: "allowCameraSettings")
                }
            })
        default:
            print("Not permission")
        }
    }
    
    //MARK: - Open Camera
    func openCamera()  {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.mediaTypes = [kUTTypeImage as String]
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }else {
            self.noCamera()
        }
    }
    
    //MARK:- no Camera Method
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - Show Alert For Camera Permission
    func showImagesAlertMessages(title:String)  {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style:.default) { (UIAlertAction) in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- UIImagePickerController Delegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let image = pickedImage as UIImage
            self.pickedImageview.image = image
            self.base64Image = self.convertImageToBase64String(img: image)
            //print(base64Image)
        }
        picker.dismiss(animated: true)
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    //MARK:- Image Upload To Server Method
      /* func imageUploadToServerMethod(imageData:[String:Data])  {
           CommonMethods.SharedInstance.showLoader()
           NetworkingManager.instance.uploadDoc(parametersDict: [:], imageDataDic: imageData, baseUrl: AppUrl.baseUrl + MethodsUrl.multipleImageUploadUrl) { (result, responseDic) in
               PrintLog.print(responseDic)
            CommonMethods.SharedInstance.hideLoader()
            if let responseArr = responseDic as? [AnyObject] {
                if result == true {
                    self.showAlertWithTitle(withTitle: projectName, andMessage: imagesUpadated) { (result) in
                        if result == true {
                         //self.documentImageView.image = self.selectedImage
                            if let respoDic = responseArr[0] as? [String:AnyObject] {
                                let imgUrl = respoDic["url"] as? String ?? ""
                                let imageUrl = AppUrl.imageUrl + "\(imgUrl)"
                                //self.documentImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: RGImages.Logo)
                                self.selectedImageStr = respoDic["url"] as? String ?? ""
                                self.updateNOCDetailsServerMethod(noc: respoDic["url"] as? String ?? "")
                            }
                            
                        }
                    }

                }

            }
        }
    }*/
}

extension InTimeViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        appendingToArray(url: myURL)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
      func appendingToArray(url: URL) {
          let filename = url.lastPathComponent
          let splitName = filename.split(separator: ".")
          let filetype = splitName.last ?? ""
          
          let docName = "\(filename)"
          do {
//              let docData = try Data(contentsOf: url)
//              arrangingDataArrays(docData: docData, docName: docName)
          }catch let error {
              print(error)
          }
      }
      
      func arrangingDataArrays(docData:Data,docName:String) {
          var dict = [String:Any]()
          dict["name"] = docName
          dict["path"] = docData
         // docsList.append(dict)
         // uploadedDocs.append(docData)
          //for imageValue in self.imagesArr {
          var uploadedDoc = [String:Data]()
          uploadedDoc[self.generateBoundaryString() + ".pdf"] = docData
          for (theKey, theValue) in uploadedDoc {
             print(theValue)
             // self.imagePathArr.insert(theKey, at: self.imagePathArr.count)
          }
         // self.uploadedDocs = uploadedDoc
          //self.imageUploadToServerMethod(imageData: self.uploadedDocs)
          //}
      }
      
      func generateBoundaryString() -> String{
          return "\(UUID().uuidString)"
      }
    
}
