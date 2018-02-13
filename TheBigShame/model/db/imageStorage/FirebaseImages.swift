

import Foundation
import Firebase

class FirebaseImages{
    
    static var storageRef = Storage.storage().reference(forURL:"gs://thebigshame-d0699.appspot.com/images")
    
    static func uploadImage(image:UIImage, filename:String, onComplete:@escaping (String?)->(Void)){
        let fileRef=storageRef.child(filename)
        
        if let data = UIImageJPEGRepresentation(image, 1){
            fileRef.putData(data,metadata:nil){ metadata, error in
                guard let metadata = metadata else {
                    Logger.log(message: error.debugDescription, event: LogEvent.e)
                    onComplete(nil)
                    return
                }
                Logger.log(message: "image \(filename) has been successfully stored on firebase", event: LogEvent.i)
                let downloadUrl = metadata.downloadURL()
                onComplete(downloadUrl?.absoluteString)
            }
        }
    }
    
    static func downloadByURL(forUrl:String, onComplete:@escaping (UIImage?)->(Void)){
        let httpsReference = Storage.storage().reference(forURL: forUrl)
        downloadImage(ref: httpsReference, onComplete: onComplete)
    }
    
    static func downloadByImageName(imageName:String, onComplete:@escaping (UIImage?)->(Void)){
        let fileRef=storageRef.child(imageName)
        downloadImage(ref: fileRef, onComplete: onComplete)
        
    }
    
    //common to both above funcs
    private static func downloadImage(ref:StorageReference,onComplete:@escaping (UIImage?)->(Void)){
        ref.getData(maxSize: 5000000) { data, error in
            if let error = error {
                Logger.log(message: error.localizedDescription, event: LogEvent.e)
                onComplete(nil)
            } else {
                Logger.log(message: "image \(ref.name) has been downloaded from firebase", event: LogEvent.i)
                let image=UIImage(data:data!)
                onComplete(image)
            }
        }
    }
    
    static func deleteByUrl(forUrl:String,onComplete:@escaping (Bool)->(Void)){
        let httpsReference = Storage.storage().reference(forURL: forUrl)
        deleteImage(ref: httpsReference, onComplete: onComplete)
        
    }
    
    static func deleteByImageName(imageName:String,onComplete:@escaping (Bool)->(Void)){
        let fileRef=storageRef.child(imageName)
        deleteImage(ref: fileRef, onComplete: onComplete)
        
    }
    
    private static func deleteImage(ref:StorageReference,onComplete:@escaping (Bool)->(Void)){
        
        ref.delete { error in
            if let error = error {
                Logger.log(message:error.localizedDescription, event: LogEvent.e)
                onComplete(false)
            } else {
                Logger.log(message:"image \(ref.name) has been successfully deleted from firebase", event: LogEvent.i)
                
                onComplete(true)    }
        }
        
    }
}
