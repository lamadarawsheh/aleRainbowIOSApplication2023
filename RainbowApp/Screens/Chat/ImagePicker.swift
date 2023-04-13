//
//  ImagePicker.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 10/04/2023.
//

import Foundation
import UIKit
import Rainbow
import InputBarAccessoryView
extension ChatViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let buttonStackView = InputStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .equalCentering
        let imageButton = InputBarButtonItem()
        imageButton.setSize(CGSize(width: 50, height: 50), animated: false)
        imageButton.setImage(tempImage, for: .normal)
        let CancelButton = InputBarButtonItem()
        CancelButton.setSize(CGSize(width: 100, height: 50), animated: false)
        CancelButton.setTitle("Cancel", for: .normal)
        CancelButton.onTouchUpInside({_ in
            for arrangedSubview in self.messageInputBar.topStackView.arrangedSubviews {
                self.messageInputBar.topStackView.removeArrangedSubview(arrangedSubview)
                arrangedSubview.removeFromSuperview()
            }
            self.messageInputBar.topStackView.isHidden = true
            self.messageInputBar.sendButton.isEnabled = false
        })
        
        buttonStackView.addArrangedSubview(imageButton)
        buttonStackView.addArrangedSubview(CancelButton)
        messageInputBar.topStackView.addArrangedSubview(buttonStackView)
        messageInputBar.topStackView.isHidden = false
        messageInputBar.sendButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
