import Foundation
import UIKit

// AJOUT DES BIBLIO
import CoreML
import Vision

class StartViewController: UIViewController {
    
    public var imagePickerController: UIImagePickerController?
    
    public var defaultImageUrl: URL?
        
        internal var selectedImage: UIImage? {
            get {
                return self.selectedImageView.image
            }
            
            set {
                switch newValue {
                case nil:
                    self.selectedImageView.image = nil
                    self.selectImageButton.isEnabled = true
                    self.selectImageButton.alpha = 1
                    
                    self.selectCameraButton.isEnabled = true
                    self.selectCameraButton.alpha = 1
                    
                    self.removeImageButton.isEnabled = false
                    self.removeImageButton.alpha = 0.5
                default:
                    self.selectedImageView.image = newValue
                    self.selectImageButton.isEnabled = false
                    self.selectImageButton.alpha = 0.5
                    self.selectCameraButton.isEnabled = false
                    self.selectCameraButton.alpha = 0.5
                    
                   // self.removeImageButton.isEnabled = true
                  //  self.removeImageButton.alpha = 1
                }
            }
        }
    
    @IBOutlet weak var selectedImageContainer: UIView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var selectCameraButton: UIButton!  {
          didSet {
                guard let button = self.selectCameraButton else { return }
                button.isEnabled = true
                button.alpha = 1
            }
       }
    
    
    @IBOutlet weak var selectImageButton: UIButton! {
            didSet {
                guard let button = self.selectImageButton else { return }
                button.isEnabled = true
                button.alpha = 1
            }
    }
    
  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
        @IBOutlet weak var removeImageButton: UIButton! {
            didSet {
                guard let button = self.removeImageButton else { return }
                button.isEnabled = false
                button.alpha = 0.5
            }
        }
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.selectedImageView.contentMode = .scaleAspectFill
            self.selectImageButton.isEnabled = self.selectedImage == nil
            self.selectImageButton.alpha = 1
            self.selectCameraButton.isEnabled = self.selectedImage == nil
            self.selectCameraButton.alpha = 1
        }
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        @IBAction func selectImageButtonAction(_ sender: UIButton) {
            /// present image picker
           
            if self.imagePickerController != nil {
                self.imagePickerController?.delegate = nil
                self.imagePickerController = nil
                
            }
            
            self.imagePickerController = UIImagePickerController.init()
            
            let alert = UIAlertController.init(title: "Select Source Type", message: nil, preferredStyle: .actionSheet)
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alert.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (_) in
                    self.presentImagePicker(controller: self.imagePickerController!, source: .camera)
                }))
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                alert.addAction(UIAlertAction.init(title: "Photo Library", style: .default, handler: { (_) in
                    self.presentImagePicker(controller: self.imagePickerController!, source: .photoLibrary)
                }))
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                alert.addAction(UIAlertAction.init(title: "Saved Albums", style: .default, handler: { (_) in
                    self.presentImagePicker(controller: self.imagePickerController!, source: .savedPhotosAlbum)
                }))
            }
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
            
            // BEGINN CROP CODE 1
            self.imagePickerController?.allowsEditing = true
            // FIN CROP CODE 1
            self.present(alert, animated: true)
        }
    
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    @IBAction func selectCameraButton(_ sender: UIButton) {
       
                        if self.imagePickerController != nil {
                              self.imagePickerController?.delegate = nil
                              self.imagePickerController = nil
                              
                          }
                          
                          self.imagePickerController = UIImagePickerController.init()
                          
                          let alert = UIAlertController.init(title: "Select Source Type", message: nil, preferredStyle: .actionSheet)
                          
                          if UIImagePickerController.isSourceTypeAvailable(.camera) {
                              alert.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (_) in
                                  self.presentImagePicker(controller: self.imagePickerController!, source: .camera)
                              }))
                          }
                          
                          alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
                          
                          // BEGINN CROP CODE 1
                          self.imagePickerController?.allowsEditing = true
                          // FIN CROP CODE 1
                          self.present(alert, animated: true)
        
    }
    
    
    
    
    
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    
        
        internal func presentImagePicker(controller: UIImagePickerController , source: UIImagePickerController.SourceType) {
            
            
            controller.delegate = self
            controller.sourceType = source
            self.present(controller, animated: true)
        }
        
        @IBAction func removeImageButtonAction(_ sender: UIButton) {
            self.selectedImage = nil
        }
    }

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    extension StartViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            
            
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                return self.imagePickerControllerDidCancel(picker)
            }
            
          
            
            // CODE AVANT CROP
            // self.selectedImage = image
            
            
            // BEGIN CROP CODE 2
                      if let image = info[.editedImage] as? UIImage{
                          self.selectedImageView.image = image
                      } else if let image = info[.originalImage] as? UIImage {
                          self.selectedImage = image
                      }
            // END CROP CODE 2
            
            
            picker.dismiss(animated: true) {
                picker.delegate = nil
                self.imagePickerController = nil
            }
            
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            // Convert UIImage to CIImage to pass to the image request handler
               guard let ciImage = CIImage(image: image) else {
                    fatalError("couldn't convert UIImage to CIImage")
               }
            
               model(image: ciImage)
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) {
                picker.delegate = nil
                self.imagePickerController = nil
            }
        }
        
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        func model(image: CIImage) {
            predictionLabel.text = "Detection glocaume"
            
            // Load the ML model through its generated class
            guard let model = try? VNCoreMLModel(for: gluco().model) else {
                fatalError("can't load MobilNet model")
            }
            
            
            // Create request for Vision Core ML model created
            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                guard let results = request.results as? [VNClassificationObservation],
                    let topResult = results.first else {
                        fatalError("unexpected result type from VNCoreMLRequest")
                }
                
                // Update UI on main queue
                DispatchQueue.main.async { [weak self] in
                    self?.predictionLabel.text = "Réponse :  \(topResult.identifier) "
                }
            }
            
            // Run the Core ML AgeNet classifier on global dispatch queue
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    try handler.perform([request])
                } catch {
                    print(error)
                }
            }
        }
}

