//
//  AppDelegate.swift
//  Goo.gl Shortener
//
//  Created by Aneesh on 10/02/16.
//  Copyright © 2016 Aneesh. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var statusMenu: NSMenu!

    @IBOutlet weak var menuItem: NSMenuItem!

    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?

    
    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        
        popover.appearance = NSAppearance(named: NSAppearanceNameAqua)


        
        if let button = statusItem.button{

            button.image = icon
            button.action = Selector("togglePopover:")

         
            button.action = Selector("togglePopover:")
            
            
        }
        
        

        popover.contentViewController = ShortenerViewController(nibName: "ShortenerViewController", bundle: nil)
        
        eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) { [unowned self] event in
            if self.popover.shown {
                self.closePopover(event)
            }

        }
        eventMonitor?.start()


        
        
       
        
    }
    

    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {

            showPopover(sender)
        }
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {

             popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
   
}

