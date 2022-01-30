//
//  Shaders.metal
//  MetalRenderer
//
//  Created by Shemetov Elisey on 29.01.2022.
//

#include <metal_stdlib>
using namespace metal;


//constant float3 color[6] = {
//    float3(1, 0, 0),
//    float3(0, 1, 0),
//    float3(0, 0, 1),
//    float3(0, 1, 1),
//    float3(0, 0, 1),
//    float3(1, 0, 0)
//};

struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
    float point_size [[point_size]];
    float3 color;
};


vertex VertexOut vertex_main(VertexIn vertexBuffer [[stage_in]],
                             device const float3 *colorBuffer [[buffer(1)]],
                             constant int &index [[buffer(2)]]) {
    VertexOut out {
        .position = vertexBuffer.position,
        .color = colorBuffer[index]
    };
    
    out.position.y -= 0.5;
    
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return  float4(in.color, 1);
}
