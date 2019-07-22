//
//  ColorValue+Pasteboard.swift
//  ImbueSwiftUI
//
//  Created by Patrick Smith on 22/7/19.
//  Copyright © 2019 Royal Icing. All rights reserved.
//

import UIKit

extension ColorValue {
    func copy(to pb: UIPasteboard) {
        guard let srgb = self.toSRGB()
            else { return }
        pb.string = srgb.hexString
    }
    
    init?(pasteboard pb: UIPasteboard) {
        if
            let string = pb.string,
            let rgb = ColorValue.RGB(hexString: string)
        {
            self = .sRGB(rgb)
            return
        }
        
        return nil
    }
}
