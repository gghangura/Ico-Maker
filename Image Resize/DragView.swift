//
//  DragView.swift
//  Image Resize
//
//  Created by Gurjit Singh on 2017-04-09.
//  Copyright © 2017 Gurjit Singh Ghangura. All rights reserved.
//

import Cocoa

class DragView: NSView  {

    var filePath: String?
    let expectedExt = ["jpg","png","JPG","PNG"]
    
    var delegate:ViewControllerDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.gray.cgColor
        
        register(forDraggedTypes: [NSFilenamesPboardType, NSURLPboardType])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            self.layer?.backgroundColor = NSColor.blue.cgColor
            return .copy
        } else {
            return NSDragOperation()
        }
    }
    
    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = board[0] as? String
            else { return false }
        
        let suffix = URL(fileURLWithPath: path).pathExtension
        for ext in self.expectedExt {
            if ext == suffix {
                return true
            }
        }
        return false
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let _ = pasteboard[0] as? String
            else { return false }
        
        //GET YOUR FILE PATH !!
        
        self.delegate = ViewController() as ViewControllerDelegate
        
        for itm in pasteboard {
            
            let finalpath = "file:///\(itm as! String)".replacingOccurrences(of: " ", with: "%20")
            self.delegate?.startProcessing(url: URL.init(string:finalpath)!)
        }
        
        return true
    }
}
