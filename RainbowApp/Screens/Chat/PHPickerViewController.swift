//
//  PHPickerViewController.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 17/04/2023.
//

import Foundation
import UIKit
import PhotosUI
extension ChatViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
           dismiss(animated: true, completion: nil)
        for result in results {
            let itemProvider = result.itemProvider
            itemProvider.loadObject(ofClass: UIImage.self) { [self] image, error in
                DispatchQueue.main.async { [self] in
                    if let image = image as? UIImage {
                        addToTopStackView(image, nil)
                      } else if let error = error {
                        print("Failed to load image: \(error.localizedDescription)")
                     } else {
                        print("Unknown error occurred while loading image.")
                     }
                }
            }
        }
    }
}
