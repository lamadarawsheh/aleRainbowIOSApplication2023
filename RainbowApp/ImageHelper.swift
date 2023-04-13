//
//  ImageConfigurations.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 27/03/2023.
//
import UIKit
import Rainbow
import Foundation
class ImageHelper {
    func configureImageView(_ imageIcon:UIImageView){
        imageIcon.layer.borderWidth = 1.0
        imageIcon.layer.masksToBounds = false
        imageIcon.layer.borderColor = UIColor.black.cgColor
        imageIcon.layer.cornerRadius = imageIcon.frame.size.width/2
        imageIcon.clipsToBounds = true
    }
    func blurEffect(_ imageIcon:UIImageView) {
        guard let image = imageIcon.image else{
            return
        }
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: image)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        imageIcon.image = processedImage
    }
    
    func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .lightGray
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        nameLabel.text = name
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    func getImage(_ data:Data? ,_ firstName:String? ,_ lastName:String?) -> UIImage? {
        if let data = data {
            return UIImage(data: data)!
        }
        else {
            var name:String = ""
            if  let firstName = firstName?.first  as? Character {
                name.append(firstName)
            }
            
            if  let lastName = lastName?.first  as? Character {
                name.append(lastName)
            }
           
            return imageWith(name: name)
        }
       
    }
}
