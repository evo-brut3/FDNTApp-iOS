//
//  PreviewEmailViewController.swift
//  FDNT
//
//  Created by Konrad Startek on 15/09/2020.
//  Copyright © 2020 Konrad Startek. All rights reserved.
//

import UIKit
import WebKit

class PreviewEmailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet var emailWebView: WKWebView!
    var message: MCOAbstractMessage?
    private let loadingVC = SpinnerViewController()
    
    private let htmlHeaderAutoSizeString = #"""
        <header><meta name='viewport' content='width=device-width, user-scalable=yes, shrink-to-fit=yes'></header>
            \#n
    """#
    
    private let htmlCSSAutoSizeString = #"""
        <style>
          body, .responsive {
            display: block;
            max-width: 100%;
            height: 100%;
            width: auto;
            word-break: break-word;
            initial-scale=1;
          }

          .image-container-fixed-size {
            width: inline;
            height: auto;
            max-width: 100%;
            max-height: auto;
          }
        </style>
        \#n
    """#
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        let webPreferences = WKPreferences()
    
        webPreferences.javaScriptEnabled = true
        webConfiguration.ignoresViewportScaleLimits = true
        webConfiguration.preferences = webPreferences
        
        emailWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        emailWebView.uiDelegate = self
        emailWebView.navigationDelegate = self
        view = emailWebView
        
        loadingVC.view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        loadingVC.spinner.style = .gray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let message = message {
            
            // Add the spinner view controller
            add(loadingVC)
            
            EmailManager.shared.renderMessageToHTML(message: message, completion: { htmlMessage in

                if let htmlMessage = htmlMessage {
                    // Attach to html string scripts and html code
                    var jsScriptContent: String = "<script>"

                    if let htmlJSScriptPath = Bundle.main.path(forResource: "MCOMessageViewScript", ofType: "js") {
                        do {
                            let st = try String(contentsOfFile: htmlJSScriptPath)
                            jsScriptContent = jsScriptContent + st + "</script>"
                        } catch {
                            print(error.localizedDescription)
                        }
                    }

                    let htmlString = jsScriptContent + self.htmlHeaderAutoSizeString + self.htmlCSSAutoSizeString + htmlMessage

                    // Render html
                    print(htmlString)
                    self.emailWebView.loadHTMLString(htmlString, baseURL: nil)
                }
                
            })
            
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // fix size of all the images that are wider than screen with
        self.emailWebView.evaluateJavaScript("fixImagesSize()", completionHandler: nil)
        
        // render inline images
        self.emailWebView.evaluateJavaScript(#"findCIDImageURL()"#, completionHandler: { (result, error) in
            if let result = result {
                print("Result of searching with JS: \(result)")
            
                do {
                    let resultString = result as? NSString
                    let data = resultString?.data(using: String.Encoding.utf8.rawValue)
                    
                    if let data = data {
                        
                        let imagesURLStrings = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray
                        
                        if let imagesURLStrings = imagesURLStrings {
                            
                            for urlString in imagesURLStrings {
                                
                                var part: MCOAbstractPart?
                                let url = NSURL(string: urlString as! String)!
                                
                                if self.isCID(url) {
                                    part = self.partForContentID(partContentID: url.resourceSpecifier)
                                } else if self.isXMailcoreImage(url) {
                                    let partUniqueID = url.resourceSpecifier
                                    part = self.partForUniqueID(partUniqueID: partUniqueID)
                                }
                                
                                if part == nil {
                                    continue
                                }
                                
                                let imapMessage = self.message as! MCOIMAPMessage
                                let imapPart = part as! MCOIMAPPart

                                EmailManager.shared.fetchAttachmentData(uid: imapMessage.uid, partID: imapPart.partID, encoding: imapPart.encoding, completion: { data in

                                    let inlineData = "data:image/jpg;base64,\(data?.base64EncodedString(options: .lineLength64Characters) ?? "")"
                                    let args = [
                                        "URLKey": urlString,
                                        "InlineDataKey": inlineData
                                    ]
    
                                    if let jsonString = self.jsonEscapedStringFromDictionary(dictionary: args) {
                                        let replaceScript = "replaceImageSrc(\(jsonString))"
                                        self.emailWebView.evaluateJavaScript(replaceScript, completionHandler: nil)
                                    }
                                })
                            }
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            } else if let error = error {
                print("An error occured while gathering CID: \(error)")
            }
            
            // Wait until signing is done and hide the spinner
            self.loadingVC.remove()
        })
    }
}

extension PreviewEmailViewController {
    
    fileprivate func jsonEscapedStringFromDictionary(dictionary: [AnyHashable : Any]?) -> String? {
        var jsonString: String?
        do {
            if let dictionary = dictionary {
                let json: Data = try JSONSerialization.data(withJSONObject: dictionary, options: .fragmentsAllowed)
                jsonString = String(bytes: json, encoding: .utf8)
            }
        } catch {
            print("jsonEscapedStringFromDictionary Error: \(error)")
        }
        return jsonString
    }
    
    fileprivate func cacheJPEGImageData(imageData: Data, withFilename filename: String) -> NSURL {
        let path = URL(fileURLWithPath: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename).path).appendingPathExtension("jpg").path
        NSData(data: imageData).write(toFile: path, atomically: true)
        return NSURL(fileURLWithPath: path)
    }
    
    func isCID(_ url: NSURL) -> Bool {
        let scheme: String? = url.scheme
        if scheme?.caseInsensitiveCompare("cid") == .orderedSame {
            return true
        }
        return false
    }
    
    func isXMailcoreImage(_ url: NSURL?) -> Bool {
        let scheme: String? = url?.scheme
        if scheme?.caseInsensitiveCompare("x-mailcore-image") == .orderedSame {
            return true
        }
        return false
    }
    
    func partForContentID(partContentID: String?) -> MCOAbstractPart? {
        let attachment = message?.part(forContentID: partContentID)
        return attachment
    }
    
    func partForUniqueID(partUniqueID: String?) -> MCOAbstractPart? {
        let attachment = message?.part(forUniqueID: partUniqueID)
        return attachment
    }
}

extension PreviewEmailViewController: MCOHTMLRendererIMAPDelegate {
    
    func mcoAbstractMessage_template(for msg: MCOAbstractMessage!) -> String! {
        return "<div style=\"padding-bottom: 20px; font-family: Helvetica; font-size: 13px;\">{{HEADER}}</div><div>{{BODY}}</div>"
    }
    
    func mcoAbstractMessage(_ msg: MCOAbstractMessage!, dataFor part: MCOIMAPPart!, folder: String!) -> Data! {
        guard let attachment = msg.part(forUniqueID: part.uniqueID) as? MCOAttachment else { return Data() }
        return attachment.data
    }
    
    func renderedHTML(withParsedMessage parser: MCOMessageParser?) -> String? {
        return parser?.htmlRendering(with: self)
    }
    
    func mcoMessageView(_ view: MCOMessageView?, dataForPartWithUniqueID partUniqueID: String?) -> Data? {
        print("dataForPartWithUniqueID")
        return message?.part(forUniqueID: partUniqueID) as! Data?
    }
}
