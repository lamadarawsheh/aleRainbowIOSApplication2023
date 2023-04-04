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
}

public struct Sender: SenderType {
    public var senderId: String
    public var displayName: String
}

 func getMessage(_ message: Rainbow.Message)-> ChatMessage{
    if message.isOutgoing {
        return ChatMessage.init(sender: ChatViewController().currentSender, messageId: message.messageID, sentDate: message.date, kind: .text(message.body!), firstName: ServicesManager.sharedInstance().myUser.contact?.firstName ?? "", LastName: ServicesManager.sharedInstance().myUser.contact?.lastName ?? "",state: message.state.rawValue)
    }
    else{
        return ChatMessage.init(sender: Sender(senderId:message.peer.rainbowID, displayName: message.peer.displayName), messageId: message.messageID, sentDate: message.date, kind: .text(message.body!), firstName: (message.peer as?Contact)?.firstName ?? "", LastName: (message.peer as?Contact)?.lastName ?? "",state: message.state.rawValue)
        }
}
//func sortMessages(_ messages: [ChatMessage])->[ChatMessage]{
//    messages.
//}
