//
//  Renderer.swift
//  MetalRenderer
//
//  Created by Shemetov Elisey on 29.01.2022.
//

import Foundation
import MetalKit

struct Vertex {
    let position: SIMD3<Float>
    let color: SIMD3<Float>
}

class Renderer: NSObject {
    static var device: MTLDevice!
    static var library: MTLLibrary!
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    
    let train: Model
    
    var timer: UInt8 = 0
    
    let colors: [SIMD3<Float>] = [
        SIMD3<Float>(0, 0.3, 0),
        SIMD3<Float>(0.4, 0, 0),
        SIMD3<Float>(0.9, 0.5, 0.0),
        SIMD3<Float>(0.8, 0.8, 0.8),
        SIMD3<Float>(0, 0.3, 0),
        SIMD3<Float>(0.4, 0, 0)
    ]
    
    let colorBuffer: MTLBuffer
    
    init(view: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue() else { fatalError("Can't connect GPU") }
        
        Renderer.device = device
        self.commandQueue = commandQueue
        Renderer.library = device.makeDefaultLibrary()
        pipelineState = Renderer.createPipleneState()
        
        let colorsLength = MemoryLayout<SIMD3<Float>>.stride * colors.count
        colorBuffer = device.makeBuffer(bytes: colors,
                                        length: colorsLength,
                                        options: [])!
        
        train = Model(name: "train")
        
        super.init()
    }
    
    static func createPipleneState() -> MTLRenderPipelineState {
        let pipleneStateDescriptor = MTLRenderPipelineDescriptor()
        
        pipleneStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        let vertexFunction = Renderer.library.makeFunction(name: "vertex_main")
        let fragmentFunction = Renderer.library.makeFunction(name: "fragment_main")
        
        pipleneStateDescriptor.vertexFunction = vertexFunction
        pipleneStateDescriptor.fragmentFunction = fragmentFunction
        pipleneStateDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultVertexDescriptor()
        
        return try! Renderer.device.makeRenderPipelineState(descriptor: pipleneStateDescriptor)
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor,
              let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
        
        commandEncoder.setRenderPipelineState(pipelineState)
        var index: Int = 0
        
        commandEncoder.setVertexBuffer(colorBuffer, offset: 0, index: 1)
        
        for mtkMesh in train.mtkMeshes {
            for vertexBuffer in mtkMesh.vertexBuffers {
                
                commandEncoder.setVertexBuffer(vertexBuffer.buffer,
                                               offset: 0,
                                               index: 0)
                
                
                
                for subMesh in mtkMesh.submeshes {
                    commandEncoder.setVertexBytes(&index, length: MemoryLayout<Int>.stride, index: 2)
                    
                    commandEncoder.drawIndexedPrimitives(type: .line,
                                                         indexCount: subMesh.indexCount,
                                                         indexType: subMesh.indexType,
                                                         indexBuffer: subMesh.indexBuffer.buffer,
                                                         indexBufferOffset: subMesh.indexBuffer.offset)
                    index += 1
                }
            }
        }
        
        commandEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
