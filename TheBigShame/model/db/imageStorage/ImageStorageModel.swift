

import Foundation
import UIKit

class ImageStorageModel {
    static func saveImage(image:UIImage, name:String, onComplete:@escaping (String?)->Void){
        FirebaseImages.uploadImage(image: image, filename: name, onComplete: { url in
            if url != nil{
                LocalImages.saveImageToFile(image: image, name: name)
            }
            onComplete(url)
        })
    }
    
    static func getImage(urlStr:String, callback:@escaping (UIImage?)->Void){
        if urlStr == ""{
            callback(nil)
            return
        }
        let url = URL(string: urlStr)
        let localImageName = url!.lastPathComponent
        let image=LocalImages.getImageFromFile(name: localImageName)
        if image != nil{
            callback(image)
        }
        else{
            FirebaseImages.downloadByURL(forUrl: urlStr, onComplete: {image in
                if image != nil {
                    LocalImages.saveImageToFile(image: image!, name: localImageName)

                }
                
                callback(image)
            })
            
        }
}
}
