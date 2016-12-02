//
//  Filters.swift
//  Filterer
//
//  Created by Mina on 12/2/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation

protocol Filters {
    // Brightness
    func brightnessFilter( pixel pixel:Pixel) -> Pixel
    // RemoveRed
    func greenFilter(pixel pixel:Pixel) -> Pixel
    // RemoveGreen
    func purppleFilter(pixel pixel:Pixel) -> Pixel
    // RemoveBlue
    func yellowFilter(pixel pixel:Pixel) -> Pixel
}
