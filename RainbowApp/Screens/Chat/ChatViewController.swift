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

class ChatViewController: MessagesViewController,MessageLabelDelegate,MessagesDataSource, CKItemsBrowserDelegate, MessagesLayoutDelegate ,reloadDataDelegate{
    public var messages = [ChatMessage]()
    var allowScrolling = true
    var isSynced = false
    var selectedURLs:[URL] = []
    public  var conversation:Conversation? = nil{
        didSet {
        }
    }
    public var messageBrowser:MessagesBrowser? = nil
    
    var currentSender: SenderType {
        return Sender(senderId: ServicesManager.sharedInstance().myUser.contact?.rainbowID ?? " ", displayName: ServicesManager.sharedInstance().myUser.contact?.displayName ?? "  " )
    }
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveComposingMessage(notification:)), name: NSNotification.Name(kConversationsManagerDidReceiveComposingMessage), object: nil)
        
        messageBrowser = ServicesManager.sharedInstance().conversationsManagerService.messagesBrowser(for: conversation, withPageSize: 20, preloadMessages: true)
        messageBrowser?.delegate = self
        if let conversation = conversation {
            title = conversation.peer?.displayName
            loadNewMessages(conversation)
            self.messagesCollectionView.scrollToLastItem()
        }
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
        // Do any additional setup after loading the view.
    }
    
    @objc func didRecieveComposingMessage(notification: NSNotification) {
        DispatchQueue.main.async{ [self] in
            print(type(of: notification.object))
            if let message = notification.object as? Rainbow.Message{
                if message.peer.rainbowID == conversation?.peer?.rainbowID{
                    if conversation?.status == .active{
                        self.setTypingIndicatorViewHidden(!message.isComposing, animated: true)
                        if allowScrolling{
                            self.messagesCollectionView.scrollToLastItem()
                        }
                    }
                }
            }
        }
    }
    func setupInputButton(){
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside({_ in
            self.presentInputActionSheet()
        })
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    func itemsBrowser(_ browser: CKItemsBrowser!, didAddCacheItems newItems: [Any]!, at indexes: IndexSet!) {
        DispatchQueue.main.async{ [self] in
            if let messages  =  newItems as? [Rainbow.Message] {
                for newItemsMessage in messages {
                    if let index = self.messages.firstIndex(where: { $0.sentDate > newItemsMessage.date }) {
                        self.messages.insert(ChatMessage(with: newItemsMessage), at: index)
                    }
                    else{
                        self.messages.append(ChatMessage(with: newItemsMessage))
                    }
                }
                self.messagesCollectionView.reloadDataAndKeepOffset()
            }
        }
    }
    
    func itemsBrowser(_ browser: CKItemsBrowser!, didRemoveCacheItems removedItems: [Any]!, at indexes: IndexSet!) {
    }
    
    func itemsBrowser(_ browser: CKItemsBrowser!, didUpdateCacheItems changedItems: [Any]!, at indexes: IndexSet!) {
        DispatchQueue.main.async{ [self] in
            if let updatedMessages = changedItems as? [Rainbow.Message] {
                for message in updatedMessages{
                    if let index =  self.messages.firstIndex(where: {$0.messageId == message.messageID}){
                        self.messages[index] =  ChatMessage(with: message)
                        self.messagesCollectionView.reloadDataAndKeepOffset()
                        self.messagesCollectionView.scrollToLastItem()
                    }
                }
            }
        }
    }
    func itemsBrowser(_ browser: CKItemsBrowser!, didReorderCacheItemsAtIndexes oldIndexes: [Any]!, toIndexes newIndexes: [Any]!) {
    }
    
    func loadNewMessages  (_ conversation:Conversation){
        if !isSynced{
            isSynced = true
            messageBrowser?.resyncBrowsingCache(completionHandler: { _,_,_,_ in
                self.messageBrowser?.nextPage(completionHandler: nil)
                ServicesManager.sharedInstance().conversationsManagerService.markAllMessagesAsRead(for: conversation)
                conversation.automaticallySendMarkAsReadNewMessage = true
            })
        }
    }
    func messageBottomLabelHeight(for message: MessageKit.MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20    }
    
    func messageBottomLabelAttributedText(for message: MessageKit.MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        guard let displayedMessage = message as? ChatMessage
        else { return nil }
        var text = "  "
        let textColor =  UIColor.black
        let textColor2 =  UIColor.blue
        let font = UIFont.systemFont(ofSize: 12, weight: .light)
        let firstDate = DateFormatterr().formate(displayedMessage.sentDate)
        let seconedDate = DateFormatterr().formate(Date())
        var date = ""
        if firstDate.compare(seconedDate) == .orderedAscending {
            date = String(displayedMessage.sentDate.formatted(date: .abbreviated, time: .shortened))
        }
        else{
            date = String(displayedMessage.sentDate.formatted(date: .abbreviated, time: .shortened).split(separator: "at").last!)
        }
        if displayedMessage.sender.senderId == ServicesManager.sharedInstance().myUser.contact?.rainbowID{
            if displayedMessage.state == 0 {
                text.append("sent")
            }
            else if displayedMessage.state == 1 {
                text.append("delivered")
            }
            else if displayedMessage.state == 2 {
                text.append("received")
            }
            else if displayedMessage.state == 3 {
                text.append("seen")
            }
            else if displayedMessage.state == 4 {
                text.append("Failed")
            }
        }
        let attributedText = NSMutableAttributedString(string: date, attributes: [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font])
        attributedText.append(NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: textColor2, NSAttributedString.Key.font: font]))
        return attributedText
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            messageBrowser?.nextPage(completionHandler: nil)
        }
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count   }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    override func viewDidAppear(_ animated: Bool) {
        ServicesManager.sharedInstance().conversationsManagerService.setStatus(.active, for: conversation)
        if allowScrolling{
            self.messagesCollectionView.scrollToLastItem()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        conversation?.automaticallySendMarkAsReadNewMessage = false
        ServicesManager.sharedInstance().conversationsManagerService.setStatus(.inactive, for: conversation)
    }
    public  func reloadData(_ url:URL , _ messageId:String) {
        if let index =  self.messages.firstIndex(where: {$0.messageId == messageId}){
            self.messages[index].kind = .video(Media(url: url, placeholderImage: UIImage(systemName: "film")!, size: CGSize(width: 80, height: 80)))
            self.messagesCollectionView.reloadDataAndKeepOffset()
        }
    }
    override func didMove(toParent parent: UIViewController?) {
        if self.parent == nil{
            conversation = nil
            messageBrowser = nil
        }
    }
}
protocol reloadDataDelegate {
    func reloadData(_ url:URL , _ messageId:String)
}
