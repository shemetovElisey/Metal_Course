//
//  ViewController.swift
//  MetalRenderer
//
//  Created by Shemetov Elisey on 29.01.2022.
//

import Cocoa
import MetalKit

class ViewController: NSViewController {
    @IBOutlet var metalView: MTKView!
    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        renderer = Renderer(view: metalView)
        metalView.device = Renderer.device
        metalView.delegate = renderer
        
        metalView.clearColor = MTLClearColor(red: 1,
                                             green: 1,
                                             blue: 0.8,
                                             alpha: 1)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

