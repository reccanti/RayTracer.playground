import Foundation
import CoreImage

/**
 * Holds pixel data
 */
public struct Pixel {
    
    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8
    
    public init(red: UInt8, green: UInt8, blue: UInt8) {
        r = red
        g = green
        b = blue
        a = 255
    }
}

/**
 * Generates an array of pixels, as well as the width and height of the screen
 */
public func makePixelSet(_ width: Int, _ height: Int) -> ([Pixel], Int, Int) {
    var pixel = Pixel(red: 0, green: 0, blue: 0)
    var pixels = [Pixel](repeating: pixel, count: width * height)
    
    let lower_left_corner = vec3(x: -2.0, y: 1.0, z: -1.0)
    let horizontal = vec3(x: 4.0, y: 0, z: 0)
    let vertical = vec3(x: 0, y: -2.0, z: 0)
    let origin = vec3()
    
    // create a blue/green gradient
    for i in 0..<width {
        for j in 0..<height {
            
            let u = Double(i) / Double(width)
            let v = Double(j) / Double(height)
            let r = ray(origin: origin, direction: lower_left_corner + u * horizontal + v * vertical)
            let col = color(r)
            
            pixel = Pixel(red: UInt8(col.x * 255), green: UInt8(col.y * 255), blue: UInt8(col.z * 255))
            pixels[i + j * width] = pixel
        }
    }
    
    return (pixels, width, height)
}

/**
 * Create an image from an array of pixels
 */
public func imageFromPixels(pixels: ([Pixel], width: Int, height: Int)) -> CIImage {
    let bitsPerComponent = 8
    let bitsPerPixel = 32
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue) // alpha is last
    
    let providerRef = CGDataProvider(data: NSData(bytes: pixels.0, length: pixels.0.count * MemoryLayout<Pixel>.size))
    
    // Hoo boy
    let image = CGImage(width:              pixels.1,
                        height:             pixels.2,
                        bitsPerComponent:   bitsPerComponent,
                        bitsPerPixel:       bitsPerPixel,
                        bytesPerRow:        pixels.1 * MemoryLayout<Pixel>.size,
                        space:              rgbColorSpace,
                        bitmapInfo:         bitmapInfo,
                        provider:           providerRef!,
                        decode:             nil,
                        shouldInterpolate:  true,
                        intent:             CGColorRenderingIntent.defaultIntent)
    
    return CIImage(cgImage: image!)
}
