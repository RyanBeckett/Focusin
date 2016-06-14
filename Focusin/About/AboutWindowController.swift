//
//  AboutWindowController.swift
//  Pomodoro
//
//  Created by Alberto Quesada Aranda on 13/6/16.
//  Copyright © 2016 Alberto Quesada Aranda. All rights reserved.
//

import Cocoa

class AboutWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
    }
    
    override var windowNibName : String! {
        return "AboutWindowController"
    }
    
    @IBAction func openIcons8(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://icons8.com")!)
    }
}
