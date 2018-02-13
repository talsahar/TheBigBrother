

import Foundation
import UIKit

class ImageStorageManager {
    static func saveImage(image:UIImage, name:String, onComplete:@escaping (String?)->Void){
        LocalImages.saveImageToFile(image: image, name: name)
        FirebaseImages.uploadImage(image: image, filename: name, onComplete: { url in
            onComplete(url)
        })
    }
    
    static func getImage(urlStr:String, callback:@escaping (UIImage?)->Void){
        let url = URL(string: urlStr)
        let localImageName = url!.lastPathComponent
        let image=LocalImages.getImageFromFile(name: localImageName)
        if image != nil{
            callback(image)
        }
        else{
            FirebaseImages.downloadByURL(forUrl: urlStr, onComplete: {image in
                callback(image)
            })
            
        }
}
}
