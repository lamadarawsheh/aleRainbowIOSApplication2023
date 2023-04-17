//
//  MessageDisplayDelegate.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 12/04/2023.
//

import Foundation
import Foundation
import InputBarAccessoryView
import Rainbow
import MessageKit
import AVKit
extension ChatViewController :MessagesDisplayDelegate,MessageCellDelegate{
    
    func configureAvatarView(_ avatarView: MessageKit.AvatarView, for message: MessageKit.MessageType, at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) {
        let avatar = getAvatar(for: message, at: indexPath, in: messagesCollectionView)
        avatarView.set(avatar: avatar)
        avatarView.backgroundColor = .clear
    }
    
    func getAvatar(for message: MessageKit.MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Avatar {
        let retrievedMessage = messages.first(where: {$0.messageId == message.messageId})
        return Avatar(image: ImageHelper().getImage(retrievedMessage?.data, retrievedMessage?.firstName, retrievedMessage?.LastName), initials: "JD")
    }
    func didTapBackground(in cell: MessageKit.MessageCollectionViewCell) {
        view.endEditing(true)
        print("tap")
    }
    
    func didTapMessage(in cell: MessageKit.MessageCollectionViewCell) {
        print("tapmessage")
    }
    
    func didTapAvatar(in cell: MessageKit.MessageCollectionViewCell) {
        print("avatar")
    }
    
    func didTapCellTopLabel(in cell: MessageKit.MessageCollectionViewCell) {
        print("tapcelltop")
    }
    
    func didTapCellBottomLabel(in cell: MessageKit.MessageCollectionViewCell) {
        print("tapcellbottom")
    }
    
    func didTapMessageTopLabel(in cell: MessageKit.MessageCollectionViewCell) {
        
    }
    
    func didTapMessageBottomLabel(in cell: MessageKit.MessageCollectionViewCell) {
        
    }
    
    func didTapAccessoryView(in cell: MessageKit.MessageCollectionViewCell) {
        
    }
    
    func didTapImage(in cell: MessageKit.MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else{
            return
        }
        let message = messages[indexPath.section]
        switch message.kind{
        case .photo(let media):
            if let image = media.image{
                let photoViewController  = self.storyboard?.instantiateViewController(identifier: "PhotoViewer") as!   PhotoViewerViewControler
                photoViewController.view.backgroundColor = .white
                photoViewController.imageIcon.image = image
                allowScrolling = false
                self.present(photoViewController, animated: true)
            }
        case .video(let media):
            if let url = media.url{
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                allowScrolling = false
                present(playerViewController, animated: true) {
                    player.play()
                }
            }
        default :
            break
        }
    }
    
    
    
    
}
