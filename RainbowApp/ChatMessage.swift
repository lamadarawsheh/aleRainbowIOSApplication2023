//
//  Message.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 30/03/2023.
//
import MessageKit
import Rainbow
import Foundation
struct ChatMessage: MessageKit.MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var data:Data?
    var firstName:String
    var LastName:String
    var state:Int
    var file:File?
    init(with message:Message){
        if message.isOutgoing{
            self.sender = Sender(senderId: ServicesManager.sharedInstance().myUser.contact?.rainbowID ?? " ", displayName: ServicesManager.sharedInstance().myUser.contact?.displayName ?? "  " )
            self.data = ServicesManager.sharedInstance().myUser.contact?.photoData
            self.firstName = ServicesManager.sharedInstance().myUser.contact?.firstName ?? ""
            self.LastName = ServicesManager.sharedInstance().myUser.contact?.lastName ?? ""
        }
        else {
            self.sender = Sender(senderId:message.peer.rainbowID, displayName: message.peer.displayName ?? "" )
            self.data = (message.peer as? Contact)?.photoData
            self.firstName = (message.peer as?Contact)?.firstName ?? ""
            self.LastName = (message.peer as?Contact)?.lastName ?? ""
        }
        self.messageId = message.messageID
        self.sentDate = message.date
        self.state = message.state.rawValue
        if message.attachment?.type == .image {
            if let data = message.attachment?.thumbnailData ?? message.attachment?.data {
                let image = UIImage(data: data)
                self.kind = .photo(Media(image:image,placeholderImage: UIImage(systemName: "photo")!, size: CGSize(width: 200, height: 200)))
            }
            else{
                self.kind = .photo(Media(image:UIImage(systemName: "photo")!,placeholderImage: UIImage(systemName: "photo")!, size: CGSize(width: 200, height: 200)))                }
        }
        else if message.attachment?.type == .video{
            if let cacheUrl = message.attachment?.cacheUrl {
                self.kind = .video(Media(url: cacheUrl, placeholderImage: UIImage(systemName: "film")!, size: CGSize(width: 80, height: 80)))
            }
            else {
                let filee = message.attachment
                self.kind = .video(Media(url: filee?.createCacheUrl(), placeholderImage: UIImage(systemName: "film")!, size: CGSize(width: 80, height: 80)))
                ServicesManager.sharedInstance().fileSharingService.downloadData(for: message.attachment, withCompletionHandler: nil
                )
            }
        }
        else{
            self.kind = .text(message.body ?? "")
        }
        self.file = message.attachment
    }
}
public struct Sender: SenderType {
    public var senderId: String
    public var displayName: String
}

public struct Media:MediaItem{
    public var url: URL?
    public var image: UIImage?
    public var placeholderImage: UIImage
    public var size: CGSize
}
