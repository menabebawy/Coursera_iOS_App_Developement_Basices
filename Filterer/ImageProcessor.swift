//
//  ImageProcessor.swift
//  Filterer
//
//  Created by Mina on 12/2/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import UIKit

//enum FilterList: String  {
//    case Brightness = "Brightness"
//    case RemoveRed = "RemoveRed"
//    case RemoveGreen = "RemoveGreen"
//    case RemoveBlue = "RemoveBlue"
//}

class ImageProcessor: NSObject, Filters {
    var image:UIImage
    var rgbaImage:RGBAImage
    
    //MARK: Init
    init(image:UIImage) {
        self.image = image
        self.rgbaImage = RGBAImage(image: self.image)!
    }
    
    func changeIntensity(intensity: Int) -> UIImage {
        for y in 0..<self.rgbaImage.height {
            for x in 0..<self.rgbaImage.width {
                let index = y * self.rgbaImage.width + x
                var pixel = self.rgbaImage.pixels[index]
                if (Int(intensity) + Int(pixel.red) > 255){
                    pixel.red = 255
                }else{
                    pixel.red += UInt8(intensity)
                }
                
                if (Int(intensity) + Int(pixel.green) > 255) {
                    pixel.green = 255
                }else {
                    pixel.green += UInt8(intensity)
                }
                
                if (Int(intensity) + Int(pixel.blue) > 255) {
                    pixel.blue = 255
                }else{
                    pixel.blue += UInt8(intensity)
                }
                
                
                self.rgbaImage.pixels[index] = pixel
            }
        }
        return self.rgbaImage.toUIImage()!
    }
    
    func implementFilter(filterIndex: Int) -> UIImage {
        for y in 0..<self.rgbaImage.height {
            for x in 0..<self.rgbaImage.width {
                let index = y * self.rgbaImage.width + x
                var pixel = self.rgbaImage.pixels[index]
                
                // loop FilterList
                switch filterIndex {
                    
                // Brightness
                case 0:
                    pixel = brightnessFilter(pixel: pixel)
                    break
                    
                // greenFilter
                case 1:
                    pixel = greenFilter(pixel: pixel)
                    break
                    
                //purppleFilter
                case 2:
                    pixel = purppleFilter(pixel: pixel)
                    break
                    
                // yellowFilter
                case 3:
                    pixel = yellowFilter(pixel: pixel)
                    break
                    
                default:
                    break
                }
                
                
                self.rgbaImage.pixels[index] = pixel
            }
        }
        return self.rgbaImage.toUIImage()!
    }
    
    // MARK: FiltersProtocols
    
    func brightnessFilter(var pixel pixel: Pixel) -> Pixel {
        // (0.2126*R + 0.7152*G + 0.0722*B)
        // Modify the pixel by the adjustment percentage
        let red = round(Double(pixel.red) * 1.5)
        let blue = round(Double(pixel.blue) * 1.5)
        let green = round(Double(pixel.green) * 1.5)
        
        // Update the pixel
        pixel.red = UInt8( max (0, min (255, red)))
        pixel.blue = UInt8( max (0, min (255, blue)))
        pixel.green = UInt8( max (0, min (255, green)))
        return pixel
    }
    
    func greenFilter(var pixel pixel: Pixel) -> Pixel {
        pixel.red = 0
        return pixel
    }
    
    
    func purppleFilter(var pixel pixel: Pixel) -> Pixel {
        pixel.green = 0
        return pixel
    }
    
    func yellowFilter(var pixel pixel: Pixel) -> Pixel {
        pixel.blue = 0
        return pixel
    }
    
}
