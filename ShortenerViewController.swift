//
//  ShortenerViewController.swift
//  Goo.gl Shortener
//
//  Created by Aneesh on 10/02/16.
//  Copyright © 2016 Aneesh. All rights reserved.
//

import Cocoa
import Alamofire

class ShortenerViewController: NSViewController {

    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var footer: NSView!
    @IBOutlet weak var progress: NSProgressIndicator!

    @IBOutlet weak var image: NSImageView!
   
  
    @IBAction func quitClick(sender: NSButton) {
        
        NSApplication.sharedApplication().terminate(self)
        
    }
    @IBOutlet weak var message: NSTextField!
    var previous:String = "hello"
    var shortUrl:String = "hello"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.message.hidden = true;
        self.image.hidden = true

        self.footer.layer?.backgroundColor = NSColor(calibratedRed: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1).CGColor


  
        
    }
    
    
    func validateUrl (stringURL : NSString) -> Bool {
        
        let urlRegEx = "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        _ = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluateWithObject(stringURL)
        
    }
    
    override func viewWillAppear() {
        
        
        let pasteBoardString = NSPasteboard.generalPasteboard().stringForType(NSPasteboardTypeString)!
        if validateUrl(pasteBoardString){
            
            if previous == pasteBoardString || pasteBoardString == shortUrl
            {
                //same url as previous show already converted
                
                self.message.stringValue = "Already Converted"
                self.image.image = NSImage(named: "alert")
                
                self.message.hidden = false
                self.image.hidden = false
                
                self.progress.stopAnimation(self)
                
                let pasteboard = NSPasteboard.generalPasteboard()
                pasteboard.clearContents()
                pasteboard.setString(self.shortUrl, forType: NSPasteboardTypeString)


            }
            else
            {
                //shorten URL
                self.message.hidden = true
                self.image.hidden = true
                self.progress.startAnimation(self)
                
               
                let parameters = ["longUrl" : "\(pasteBoardString)"]
                print("Sending Request...\n")
                Alamofire.request(.POST, "https://www.googleapis.com/urlshortener/v1/url?key=<INSERT KEY HERE>", parameters: parameters, encoding: .JSON, headers: ["Content-Type" : "application/json"]).responseJSON{ response in
                    
                    if let JSON = response.result.value {
                        
                        let r = JSON as! NSDictionary
                        
                        let short = r.objectForKey("id")!
                        
                        self.message.stringValue = "Converted and Copied"

                        let pasteboard = NSPasteboard.generalPasteboard()
                        pasteboard.clearContents()
                        pasteboard.setString(short as! String, forType: NSPasteboardTypeString)
                        
                        self.image.image = NSImage(named:"done")
                        self.progress.stopAnimation(self)
                        self.message.hidden = false
                        self.image.hidden = false
                        self.shortUrl = short as! String
                    }
                }

                
                previous = pasteBoardString

            }
        }
        else
        {
            self.message.stringValue = "Not a Valid URL"
            self.image.image = NSImage(named: "wrong")
            
            self.message.hidden = false
            self.image.hidden = false
            //not a valid URL show wrong
            self.progress.stopAnimation(self)
        }
        
    
        
        
    }
    
    

    

    
}
