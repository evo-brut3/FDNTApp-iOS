//
//  EmailManager.swift
//  FDNT
//
//  Created by Konrad Startek on 13/09/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import Foundation

// MARK: Observer
protocol EmailManagerObserver: class {
    func emailManager(_ manager: EmailManager, didStartDownloading: Bool)
    func emailManager(_ manager: EmailManager, didStopDownloading: EmailManager.Items)
}

extension EmailManagerObserver {
    func emailManager(_ manager: EmailManager, didStartDownloading: Bool) {}
    func emailManager(_ manager: EmailManager, didStopDownloading: EmailManager.Items) {}
}

private extension EmailManager {
    struct Observation {
        weak var observer: EmailManagerObserver?
    }
}

private extension EmailManager {
    func didStateChange() {
        for (id, observation) in observations {
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }
            
//            switch state {
//            case <#pattern#>:
//                <#code#>
//            default:
//                <#code#>
//            }
        }
    }
}

// MARK: Email Model
enum EmailFolderType: String, CaseIterable {
    case INBOX
    case SENT
    case SPAM
    
    var directory: String {
        return self.rawValue
    }
    
    var name: String {
        switch self {
        case .INBOX: return "Odebrane"
        case .SENT: return "Wysłane"
        case .SPAM: return "Spam"
        }
    }
    
}

class EmailManager {
    typealias Items = [EmailFolderType: [MCOAbstractMessage]]
    
    private var observations = [ObjectIdentifier: Observation]()

    static let shared = EmailManager()
    public private(set) var isDownloadingNewMessages = false
    
    fileprivate var session: MCOIMAPSession = MCOIMAPSession()
    private var emails: EmailManager.Items = [:]
    
    private let password = "yCFRJIR!Tz7B"
    
    // MARK: Connection, configuration and fetching
    func connect(login: String, password: String, completion: @escaping (Bool) -> ()) {
        
        session = MCOIMAPSession()
        
        session.hostname = "mail.dzielo.pl"
        session.port = 993
        session.username = login
        session.password = self.password
        session.connectionType = MCOConnectionType.TLS
        
        let accountOperation = session.checkAccountOperation()
        
        accountOperation?.start({ error in
            if error == nil {
                completion(true)
            } else {
                print("EmailManager: connect - error \(String(describing: error))")
                completion(false)
            }
            
        })
        
    }

    func fetch() {
//        for folderType in EmailFolderType.allCases {
            
//            let folder = folderType.directory
//            let uids = MCOIndexSet(range: MCORangeMake(1, UINT64_MAX))
//
//            let folderStatusOperation = session.folderStatusOperation(folder)
//            folderStatusOperation?.start { (error, folderStatus) in
//                print("\n=== folder: \(folderType.name) ===")
//                print("UIDNEXT        : \(folderStatus?.uidNext)")
//                print("no. of messages: \(folderStatus?.messageCount)")
//            }
            
//            for uid in uids {
//
//                // Create IMAP-Fetch operation
//                let fetchOperation = session.fetchMessageOperation(withFolder: folder, uid: UInt32(uid))
//
//                // Start IMAP-Fetch operation
//                fetchOperation?.start { (error, data) in
//                    let messageParser = MCOMessageParser(data: data)
//
//                    guard let messageHTMLBody = messageParser?.htmlRendering(with: nil) else { return }
//
//                    print(messageHTMLBody)
//                    print("\n", "\n", "\n", "\n", "\n")
//                }
//
//            }
                        
//        }
        
        for folderType in EmailFolderType.allCases {

            let requestKind = MCOIMAPMessagesRequestKind(arrayLiteral: [ .headers, .structure, .extraHeaders ])
            let folder = folderType.directory
            let uids = MCOIndexSet(range: MCORangeMake(1, UINT64_MAX))

            let fetchOperation = session.fetchMessagesOperation(withFolder: folder, requestKind: requestKind, uids: uids)
            
//            fetchOperation?.progress = { (current: UInt32) in
//                print("current message: \(current)")
//            }
            
            
            if let fetchOperation = fetchOperation {
                
                isDownloadingNewMessages = true
                
                fetchOperation.start({ error, fetchedMessages, vanishedMessages in
                    
                    if let error = error {
                        print("Error while downloading message headers: \(error)")
                    } else if let fetchedMessages = fetchedMessages as? [MCOAbstractMessage]{
                        self.emails[folderType] = fetchedMessages.reversed()
                    }
                    
                    self.isDownloadingNewMessages = false
                })
            }

        }
        
    }
    
    func renderMessageToHTML(message: MCOAbstractMessage, completion: @escaping (String?) -> ()) {
        let renderOperation = session.htmlBodyRenderingOperation(with: message as? MCOIMAPMessage, folder: EmailFolderType.INBOX.directory)
        renderOperation?.start({ (html, error) in
            if error != nil {
                print("Error while render a message: \(String(describing: error))")
            }
            completion(html)
        })
    }
    
    func fetchAttachmentData(uid: UInt32, partID: String, encoding: MCOEncoding, completion: @escaping (Data?) -> ()) {
        let fetchAttachmentOperation = session.fetchMessageAttachmentOperation(withFolder: EmailFolderType.INBOX.directory, uid: uid, partID: partID, encoding: encoding)
        fetchAttachmentOperation?.start({ error, data in
            if let error = error {
                print("An error has ocurred while fetching attachment data: \(error.localizedDescription)")
            } else if let data = data {
                completion(data)
            }
        })
    }
    
    func searchForTextInMessages(searchedText: String) {
        
    }
    
    // MARK: Emails management
    func countEmails(folderType: EmailFolderType) -> Int {
        return emails[folderType]?.count ?? 0
    }

    func getEmailFrom(index: Int, folderType: EmailFolderType) -> String? {
        
        if let emailsArray = emails[folderType] {
            
            let email = emailsArray[index] as MCOAbstractMessage
            return email.header.from.displayName ?? email.header.from.mailbox
        }
        
        return nil
    }

    func getEmailSubject(index: Int, folderType: EmailFolderType) -> String? {
        
        if let emailsArray = emails[folderType] {
        
            let email = emailsArray[index] as MCOAbstractMessage
            return email.header.subject
        }
        
        return nil
    }

    func getEmailBody(index: Int, folderType: EmailFolderType,completion: @escaping (String?) -> ()) {
        
        guard let emailsArray = emails[folderType] else {
            completion(nil)
            return
        }
        
        let email = emailsArray[index] as MCOAbstractMessage
        let htmlRenderingOperation = session.htmlBodyRenderingOperation(with: email as? MCOIMAPMessage, folder: "INBOX")
        var emailHTMLBody: String?

        htmlRenderingOperation?.start({ html, error in
            if error != nil {
                print("An error occured while rendering: \(error!.localizedDescription))")
            }
            
            emailHTMLBody = html
            completion(emailHTMLBody)
        })
    }

    func getMessage(index: Int, folderType: EmailFolderType) -> MCOAbstractMessage {
        let emailsArray = emails[folderType]!
        return emailsArray[index] as MCOAbstractMessage
    }
}
