//
//  AppDelegate.swift
//  Image Resize
//
//  Created by Gurjit Singh on 2017-04-09.
//  Copyright © 2017 Gurjit Singh Ghangura. All rights reserved.
//

import Cocoa

protocol ViewControllerDelegate  {
    func pickImage(_ sender: Any)
    func startProcessing(url : URL) 
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var delegate:ViewControllerDelegate?

    @IBAction func openAction(_ sender: Any) {
        self.delegate = ViewController() as ViewControllerDelegate
        self.delegate?.pickImage(self)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        
        return true
    }


}

