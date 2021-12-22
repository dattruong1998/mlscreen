import Vision
import FirebaseCore
import MLKit

class FlutterChannelManager: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  let channel: FlutterMethodChannel
  let flutterViewController: FlutterViewController
  
  init(flutterViewController: FlutterViewController) {
    self.flutterViewController = flutterViewController
    channel = FlutterMethodChannel(name: "ocr", binaryMessenger: flutterViewController.binaryMessenger)
  }
  
    func setup() {
        // 2. set method call handler
        channel.setMethodCallHandler { (call, result) in
          // 3. check call method and arguments
          switch call.method {
          case "doOcr":
            if let args = call.arguments as? Dictionary<String, Any>,
               let path = args["path"] as? String {
                let image = UIImage(contentsOfFile: path)
                let visionImage = VisionImage(image: image!)
                let textRecognizer = TextRecognizer.textRecognizer()
                textRecognizer.process(visionImage) { txtresult, error in
                    guard error == nil, let textresult = txtresult else {
                      return
                    }
                    result(textresult.text)
                  }
                
            }
//                let image = UIImage(contentsOfFile: path)?.cgImage
//                if #available(iOS 13.0, *) {
//                    let handler = VNImageRequestHandler(cgImage: image!, options: [:])
//                    let request = VNRecognizeTextRequest { request, error in
//                        let observations = request.results as? [VNRecognizedTextObservation]
//
//
//                        observations!.compactMap{observation in
//
//                        }
//
//                    }
//                    request.recognitionLevel = .accurate
//                    do {
//                        try handler.perform([request])
//                    } catch let error {
//                        print(error)
//                    }
//                } else {
//                   print("IOS is not accepted")
//                }
//
//
//             } else {
//               result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
//             }
          default:
            break
          }
        }
      }
      
    func buildImagePicker(sourceType: UIImagePickerController.SourceType, completion: @escaping (_ result: Any?) -> Void) -> UIViewController {
        if sourceType == .camera && !UIImagePickerController.isSourceTypeAvailable(.camera) {
          let alert = UIAlertController(title: "Error", message: "Camera not available", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            completion(FlutterError(code: "camera_unavailable", message: "camera not available", details: nil))
          })
          return alert
        } else {
          return ImagePickerController(sourceType: sourceType) { image in
            self.flutterViewController.dismiss(animated: true, completion: nil)
            if let image = image {
              completion(self.saveToFile(image: image))
            } else {
              completion(FlutterError(code: "user_cancelled", message: "User did cancel", details: nil))
            }
          }
        }
      }
      
      private func saveToFile(image: UIImage) -> Any {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
          return FlutterError(code: "image_encoding_error", message: "Could not read image", details: nil)
        }
        let tempDir = NSTemporaryDirectory()
        let imageName = "image_picker_\(ProcessInfo().globallyUniqueString).jpg"
        let filePath = tempDir.appending(imageName)
        if FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil) {
          return filePath
        } else {
          return FlutterError(code: "image_save_failed", message: "Could not save image to disk", details: nil)
        }
      }
    }


