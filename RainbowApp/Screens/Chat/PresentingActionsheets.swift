//
//  PresentingActionsheets.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 12/04/2023.
//

import Foundation
import UIKit
extension ChatViewController {
    func presentInputActionSheet(){
        let actionSheet = UIAlertController(title: "Attach Media", message: "what would u like to attach?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default,handler:{ [self]_ in
            presentPhotoActionSheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default ,handler: {
            _ in
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = false
                picker.mediaTypes = ["public.movie"]
                self.present(picker, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet,animated: true)
    }
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Attach Photo", message: "choose photo from ", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default,handler:{ [self]_ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default,handler: {_ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet,animated: true)
    }
}
