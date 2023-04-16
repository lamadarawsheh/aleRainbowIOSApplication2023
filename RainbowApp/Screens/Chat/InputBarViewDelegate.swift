//
//  InputBarViewDelegate.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 02/04/2023.
//

import Foundation
import InputBarAccessoryView
import Rainbow
import MessageKit
extension ChatViewController: InputBarAccessoryViewDelegate {
    @objc
    func inputBar(_: InputBarAccessoryView, didPressSendButtonWith _: String) {
        guard let attributedText = messageInputBar.inputTextView.attributedText else {
            return
        }
        guard let conversation = self.conversation else{
            return
        }
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { _, range, _ in
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        
        self.messageInputBar.sendButton.stopAnimating()
        self.messageInputBar.inputTextView.placeholder = "Aa"
        
        if let message = messageInputBar.inputTextView.text {
            if !message.isEmpty{
                ServicesManager.sharedInstance().conversationsManagerService.sendTextMessage(message, files: nil, mentions: nil, priority: .default, repliedMessage: nil, conversation:conversation)
            }
            if !messageInputBar.topStackView.arrangedSubviews.isEmpty{
                for arrangedSubview in self.messageInputBar.topStackView.arrangedSubviews {
                    let subView =  arrangedSubview as? InputStackView
                    if selectedURLs.isEmpty{
                        let imageView = subView?.arrangedSubviews.first as? InputBarButtonItem
                        let imageData =   imageView?.image?.pngData()
                        if  let file =  ServicesManager.sharedInstance().fileSharingService.createTemporaryFile(withFileName: "image.png", andData: imageData, andURL: nil){
                            let files = [file]
                            ServicesManager.sharedInstance().conversationsManagerService.sendTextMessage(nil, files: files, mentions: nil, priority: .default, repliedMessage: nil, conversation: conversation)
                        }
                    }
                    else{
                        let url = selectedURLs.first
                        if  let file =  ServicesManager.sharedInstance().fileSharingService.createTemporaryFile(withFileName: "video.mov", andData: nil, andURL: url){
                            let files = [file]
                            ServicesManager.sharedInstance().conversationsManagerService.sendTextMessage(nil, files: files, mentions: nil, priority: .default, repliedMessage: nil, conversation: conversation)
                        }
                    }
                }
                selectedURLs.removeAll()
                for arrangedSubview in self.messageInputBar.topStackView.arrangedSubviews {
                    self.messageInputBar.topStackView.removeArrangedSubview(arrangedSubview)
                    arrangedSubview.removeFromSuperview()
                }
                
            }
            
        }
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        self.messagesCollectionView.reloadDataAndKeepOffset()
        self.messagesCollectionView.scrollToLastItem()
        
    }
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        print(isTypingIndicatorHidden)
        if text.isEmpty
        {
            ServicesManager.sharedInstance().conversationsManagerService.setStatus(.active, for: conversation)
        }
        else{
            ServicesManager.sharedInstance().conversationsManagerService.setStatus(.composing, for: conversation)
        }}
    
}

