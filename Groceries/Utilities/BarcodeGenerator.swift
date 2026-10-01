//
//  BarcodeGenerator.swift
//  Locarey
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import CoreImage.CIFilterBuiltins
import UIKit

enum BarcodeGenerator {
    /// Draws `message` as a Code 128 barcode using Core Image's built-in generator.
    static func code128(from message: String) -> UIImage? {
        let filter = CIFilter.code128BarcodeGenerator()
        filter.message = Data(message.utf8)
        filter.quietSpace = 10

        // One point per bar by default, so scale up before rasterising.
        guard let output = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: 4, y: 4)),
              let cgImage = CIContext().createCGImage(output, from: output.extent)
        else { return nil }

        return UIImage(cgImage: cgImage)
    }
}
