//
//  AdjustableColorInstance.swift
//  ImbueSwiftUI
//
//  Created by Patrick Smith on 21/7/19.
//  Copyright © 2019 Royal Icing. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


class AdjustableColorInstance : ObservableObject {    
    struct State {
        var inputColor: ColorValue = ColorValue.labD50(ColorValue.Lab(l: 50, a: 0, b: 0))
        var lightenAmount: CGFloat = 0.0
        var darkenAmount: CGFloat = 0.0
        var desaturateAmount: CGFloat = 0.0
        var invert: Bool = false
    }
    
    @Published var state: State
    
    init(state: State) {
        self.state = state;
    }
    
    private enum Step : Int {
        case lighten = 0
        case darken
        case desaturate
        case invert
        
        var index: Int { rawValue }
    }
    
    private func transform(color: ColorValue, upTo: Step) -> ColorValue {
        var rgb = color.toSRGB()!
        for step in 0 ... upTo.index {
            switch step {
            case Step.lighten.index:
                rgb = rgb.lightened(amount: state.lightenAmount)
            case Step.darken.index:
                rgb = rgb.darkened(amount: state.darkenAmount)
            case Step.desaturate.index:
                rgb = rgb.desaturated(amount: state.desaturateAmount)
            case Step.invert.index:
                if state.invert {
                    rgb = rgb.inverted()
                }
            default:
                break
            }
        }
        return ColorValue.sRGB(rgb)
    }
    
    var outputColor: ColorValue {
        transform(color: state.inputColor, upTo: .invert)
    }
}
