//
//  Extensions.swift
//  MetalRenderer
//
//  Created by Shemetov Elisey on 30.01.2022.
//

import Foundation
import MetalKit

extension MTLVertexDescriptor {
    static func defaultVertexDescriptor() -> MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<SIMD3<Float>>.stride
        
        return vertexDescriptor
    }
}

extension MDLVertexDescriptor {
    static func defaultVertexDescriptor() -> MDLVertexDescriptor {
        let vertexDescritor = MTKModelIOVertexDescriptorFromMetal(.defaultVertexDescriptor())
        
        let attributePosition = vertexDescritor.attributes[0] as! MDLVertexAttribute
        attributePosition.name = MDLVertexAttributePosition
        
        
        return vertexDescritor
    }
}
