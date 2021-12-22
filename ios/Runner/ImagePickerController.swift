
import Foundation
import UIKit

class ImagePickerController: UIImagePickerController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var handler: ((_ image: UIImage?) -> Void)?
  
    convenience init(sourceType: UIImagePickerController.SourceType, handler: @escaping (_ image: UIImage?) -> Void) {
    self.init()
    self.sourceType = sourceType
    self.delegate = self
    self.handler = handler
  }
  
  private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        handler?(info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage)
    
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    handler?(nil)
  }
}
