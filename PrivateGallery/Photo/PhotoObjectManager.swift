
import Foundation
import UIKit


enum Keys: String{
    case firstKey = "firstKey"
}

class PhotoObjectManager {
  
    static let shared = PhotoObjectManager()
    

    let photoObject = PhotoObject()
    
    func getPhotoObject() -> [PhotoObject] {
        if let photoObject = UserDefaults.standard.value([PhotoObject].self, forKey: Keys.firstKey.rawValue){
            return photoObject
        }else
        {return [PhotoObject]() }
    }
    
    
    func setPhotoObject(photoObject: PhotoObject){
    
        var photoArray = PhotoObjectManager.shared.getPhotoObject()
        photoArray.append(photoObject)
        UserDefaults.standard.set(encodable: photoArray, forKey: Keys.firstKey.rawValue)
      
    }
    
    func saveImage(image: UIImage) -> String? {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}

            let fileName = UUID().uuidString
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            guard let data = image.jpegData(compressionQuality: 1) else { return nil}

            //Checks if file exists, removes it if so.
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    print("Removed old image")
                } catch let removeError {
                    print("couldn't remove file at path", removeError)
                }

            }

            do {
                try data.write(to: fileURL)
                return fileName
            } catch let error {
                print("error saving file with error", error)
                return nil
            }

        }



    func loadSave(fileName:String) -> UIImage? {
            let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

            let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

            if let dirPath = paths.first {
                let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
                let image = UIImage(contentsOfFile: imageUrl.path)
                return image

            }
            return nil
        }

}