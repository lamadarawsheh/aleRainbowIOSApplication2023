//
//  Message.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 30/03/2023.
//
import MessageKit
import Foundation
struct Message: MessageKit.MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var data:Data?
    var firstName:String
    var LastName:String
}

public struct Sender: SenderType {
    public var senderId: String
    public var displayName: String
}
