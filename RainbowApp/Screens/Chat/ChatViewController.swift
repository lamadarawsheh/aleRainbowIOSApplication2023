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

class ChatViewController: MessagesViewController,MessageLabelDelegate,MessagesDataSource, CKItemsBrowserDelegate, MessageCellDelegate, MessagesDisplayDelegate, MessagesLayoutDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func typingIndicatorViewSize(for layout: MessageKit.MessagesCollectionViewFlowLayout) -> CGSize {
        return CGSize(width: 20, height: 30)
    }
    
    func typingIndicatorViewTopInset(in messagesCollectionView: MessageKit.MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    
    var messages = [ChatMessage]()
    var allowScrolling = true
    var isSynced = false
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
        if let conversation = conversation {
            title = conversation.peer?.displayName
            loadNewMessages(conversation)
        }
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
        // Do any additional setup after loading the view.
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
    func presentInputActionSheet(){
        let actionSheet = UIAlertController(title: "Attach Media", message: "what would u like to attach?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default,handler:{ [self]_ in
            presentPhotoActionSheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default))
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet,animated: true)
    }
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Attach Photo", message: "choose photo from ", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default,handler:{ [self]_ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default,handler: {_ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet,animated: true)
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
            if let messages  =  newItems! as? [Rainbow.Message] {
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
                    let index =  self.messages.firstIndex(where: {$0.messageId == message.messageID})
                    self.messages[index!] =  ChatMessage(with: message)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.messagesCollectionView.scrollToLastItem()
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
        self.messagesCollectionView.scrollToLastItem()
    }
    deinit{
        conversation?.automaticallySendMarkAsReadNewMessage = false
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageData = tempImage.pngData()
        if  let file =  ServicesManager.sharedInstance().fileSharingService.createTemporaryFile(withFileName: "image.png", andData: imageData, andURL: nil){
            let files = [file]
            ServicesManager.sharedInstance().conversationsManagerService.sendTextMessage("image.png", files: files, mentions: nil, priority: .default, repliedMessage: nil, conversation: conversation!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
