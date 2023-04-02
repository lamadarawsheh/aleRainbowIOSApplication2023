//
//  ChatViewController.swift
//  RainbowApp
//
//  Created by Lama Darawsheh on 28/03/2023.
//
import Rainbow
import InputBarAccessoryView
import UIKit
import MessageKit


class ChatViewController: MessagesViewController, MessagesLayoutDelegate,MessagesDataSource, CKItemsBrowserDelegate, MessageCellDelegate, MessagesDisplayDelegate {
    var messages = [Message]()
    var isFirstTime = true
    public  var conversation:Conversation? = nil{
        didSet {
        }
    }
    var messageBrowser:MessagesBrowser? = nil{
        didSet{
        }
    }
    var currentSender: SenderType {
        return Sender(senderId: ServicesManager.sharedInstance().myUser.contact?.rainbowID ?? " ", displayName: ServicesManager.sharedInstance().myUser.contact?.displayName ?? "  " )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        messageBrowser = ServicesManager.sharedInstance().conversationsManagerService.messagesBrowser(for: conversation, withPageSize: 20, preloadMessages: true)
        messageBrowser?.delegate = self
        loadNewMessages(conversation!)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        // Do any additional setup after loading the view.
    }
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
        
    }
    func itemsBrowser(_ browser: CKItemsBrowser!, didAddCacheItems newItems: [Any]!, at indexes: IndexSet!) {
        DispatchQueue.main.async{ [self] in
            let messages  =  newItems!
            for newItemsMessage in messages {
                if let message = newItemsMessage as? Rainbow.Message {
                    if message.isOutgoing {
                        self.messages.append(Message(sender: currentSender, messageId: (message.messageID)!, sentDate: (message.date)!, kind: .text(message.body!),data: ServicesManager.sharedInstance().myUser.contact?.photoData ,firstName: ServicesManager.sharedInstance().myUser.contact?.firstName ?? "" ,LastName: ServicesManager.sharedInstance().myUser.contact?.lastName ?? ""))
                    }
                    else{
                        self.messages.append(Message(sender: Sender(senderId:message.peer.rainbowID, displayName: message.peer.displayName), messageId: (message.messageID)!, sentDate: (message.date)!, kind: .text(message.body!),data: (message.peer as? Contact)?.photoData ,firstName: (message.peer as?Contact)?.firstName ?? "" , LastName: (message.peer as?Contact)?.lastName ?? ""))
                    }
                }
            }
            self.messages =  self.messages.sorted(by: {$0.sentDate < $1.sentDate})
            self.loadFirstMessages()
        }
    }
    
    func itemsBrowser(_ browser: CKItemsBrowser!, didRemoveCacheItems removedItems: [Any]!, at indexes: IndexSet!) {
    }
    
    func itemsBrowser(_ browser: CKItemsBrowser!, didUpdateCacheItems changedItems: [Any]!, at indexes: IndexSet!) {
    }
    
    
    func itemsBrowser(_ browser: CKItemsBrowser!, didReorderCacheItemsAtIndexes oldIndexes: [Any]!, toIndexes newIndexes: [Any]!) {
    }
    
    func loadNewMessages  (_ conversation:Conversation){
        if conversation.lastMessage?.date == Date(){
            messageBrowser?.resyncBrowsingCache(completionHandler: nil)
            loadNewMessages(conversation)
        }
        else{
            messageBrowser?.nextPage(completionHandler: nil)
        }
    }
    
    override func scrollViewDidEndDecelerating(_: UIScrollView) {
        messageBrowser?.nextPage(completionHandler: nil)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count   }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    func loadFirstMessages() {
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadDataAndKeepOffset()
            if self.isFirstTime {
                self.messagesCollectionView.scrollToLastItem()
                self.isFirstTime = false
            }
        }
    }
}

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
            sleep(1)
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
                self!.loadFirstMessages()
            }
        }
    }
}



