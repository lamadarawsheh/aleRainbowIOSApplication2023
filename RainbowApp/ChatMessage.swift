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
    
    init(with message:Message)
    {
        if message.isOutgoing{
            self.sender = ChatViewController().currentSender
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
        if let data = message.attachment?.thumbnailData ?? message.attachment?.data {
            let image = UIImage(data: data)
            self.kind = .photo(Media(image:image,placeholderImage: UIImage(systemName: "plus")!, size: CGSize(width: 200, height: 200)))
        }
        else{
            self.kind = .text(message.body ?? "")
        }
        self.state = message.state.rawValue
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
