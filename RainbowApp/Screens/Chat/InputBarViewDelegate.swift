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
        
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { _, range, _ in
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        let components = messageInputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            DispatchQueue.main.async { [weak self] in
                self!.messageInputBar.sendButton.stopAnimating()
                self!.messageInputBar.inputTextView.placeholder = "Aa"
                for component in components {
                    if let message = component as? String {
                        ServicesManager.sharedInstance().conversationsManagerService.sendTextMessage(message, files: nil, mentions: nil, priority: .default, repliedMessage: nil, conversation: self!.conversation!)
                    } else {
                        //send an image for example
                    }
                }
                self!.messagesCollectionView.reloadDataAndKeepOffset()
                self!.messagesCollectionView.scrollToLastItem()
            }
        }
    }
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
    }
    override func setTypingIndicatorViewHidden(_ isHidden: Bool, animated: Bool, whilePerforming updates: (() -> Void)? = nil, completion: ((Bool) -> Void)? = nil) {
        
    }
}

