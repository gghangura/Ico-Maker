//
//  ViewController.swift
//  Image Resize
//
//  Created by Gurjit Singh on 2017-04-09.
//  Copyright © 2017 Gurjit Singh Ghangura. All rights reserved.
//

import Cocoa


class ViewController: NSViewController, NSApplicationDelegate, ViewControllerDelegate {
    
    var image = NSImage()

    @IBOutlet weak var dragView: DragView!
    @IBOutlet weak var imageView: NSImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

            
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func pickImage(_ sender: Any) {
        
        let openDlg = NSOpenPanel.init()
        
        openDlg.canChooseFiles = true
        
        openDlg.allowedFileTypes = ["jpg","png","JPG","PNG"]
        
        openDlg.allowsMultipleSelection = true
        
        openDlg.canChooseDirectories = false
        
        if openDlg.runModal() == NSModalResponseOK {
            
            let files = openDlg.urls
            
            for itm in files {
                startProcessing(url: itm)
            }
            
        }
        
    }
    
    func startProcessing(url : URL) {
        
        image = NSImage.init(contentsOf: url)!
        
        let width = image.size.width / 3
        
        let height = image.size.height / 3
        
        for i in 1...3 {
            
            let resizedImage = resize(image: self.image, w: width * CGFloat(i), h: height * CGFloat(i))
            
            let data = resizedImage.tiffRepresentation
            
            let paths = url.absoluteString.components(separatedBy: "/")
            
            var finalPath = paths[0]
            
            let fileExtention = url.absoluteString.components(separatedBy: ".").last
            
            let imageName = paths[paths.count - 1].replacingOccurrences(of: ".\(String(describing: fileExtention!))", with: "")
            
            for pathComponent in 1..<paths.count - 1 {
                finalPath += "/\(paths[pathComponent])"
            }
            
            finalPath += "/\(String(describing: imageName)).imageset"
            
            
            if i == 1 {
                
                let image1Dic = ["idiom" : "universal", "filename" : "\(String(describing: imageName.replacingOccurrences(of: "%20", with: " "))).\(String(describing: fileExtention!))", "scale" : "1x"]
                
                let image2Dic = ["idiom" : "universal", "filename" : "\(String(describing: imageName.replacingOccurrences(of: "%20", with: " ")))@2x.\(String(describing: fileExtention!))", "scale" : "2x"]
                
                let image3Dic = ["idiom" : "universal", "filename" : "\(String(describing: imageName.replacingOccurrences(of: "%20", with: " ")))@3x.\(String(describing: fileExtention!))", "scale" : "3x"]
                
                let infoDic = ["version" : 1, "author" : "xcode"] as [String : Any]
                
                let arrofImages = [image3Dic, image2Dic, image1Dic]
                
                let jsonObject = [
                    "info": infoDic,
                    "images": arrofImages
                ] as [String : Any]
                
                
                let contentsdata =  try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                
                do {
                    try FileManager.default.createDirectory(at: URL.init(string: finalPath)!, withIntermediateDirectories: false, attributes: nil)
                    try contentsdata.write(to: URL.init(string: finalPath.appending("/Contents.json"))!)
                }
                catch {
                    
                }
                
                finalPath += "/\(String(describing: imageName)).\(String(describing: fileExtention!))"
            } else {
                finalPath += "/\(String(describing: imageName))@\(i)x.\(String(describing: fileExtention!))"
            }
            
            finalPath = finalPath.replacingOccurrences(of: " ", with: "%20")
            
            do {
                try data?.write(to: URL.init(string: finalPath)!)
            }
            catch {
                
            }
            
        }
        
    }
    
    func resize(image: NSImage, w: CGFloat, h: CGFloat) -> NSImage {
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        return NSImage(data: newImage.tiffRepresentation!)!
    }
    
}
