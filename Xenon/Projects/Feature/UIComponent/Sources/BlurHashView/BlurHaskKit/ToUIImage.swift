import UIKit
import NetworkingFeature

extension BlurHash {
    
    @BackgroundActor
    public func cgImage(size: CGSize) async -> CGImage? {
		let width = Int(size.width)
		let height = Int(size.height)
		let bytesPerRow = width * 3

		guard let data = CFDataCreateMutable(kCFAllocatorDefault, bytesPerRow * height) else { return nil }
		CFDataSetLength(data, bytesPerRow * height)

		guard let pixels = CFDataGetMutableBytePtr(data) else { return nil }

		for y in 0 ..< height {
			for x in 0 ..< width {
				var c: (Float, Float, Float) = (0, 0, 0)

				for j in 0 ..< numberOfVerticalComponents {
					for i in 0 ..< numberOfHorizontalComponents {
						let basis = cos(Float.pi * Float(x) * Float(i) / Float(width)) * cos(Float.pi * Float(y) * Float(j) / Float(height))
						let component = components[j][i]
						c += component * basis
					}
				}

				let intR = UInt8(linearTosRGB(c.0))
				let intG = UInt8(linearTosRGB(c.1))
				let intB = UInt8(linearTosRGB(c.2))

				pixels[3 * x + 0 + y * bytesPerRow] = intR
				pixels[3 * x + 1 + y * bytesPerRow] = intG
				pixels[3 * x + 2 + y * bytesPerRow] = intB
			}
		}

		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

		guard let provider = CGDataProvider(data: data) else { return nil }
		guard let cgImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 24, bytesPerRow: bytesPerRow,
		space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else { return nil }

		return cgImage
	}
}
