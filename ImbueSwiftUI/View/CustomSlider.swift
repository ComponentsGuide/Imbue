//
//  CustomSlider.swift
//  ImbueSwiftUI
//
//  Created by Patrick Smith on 22/7/19.
//  Copyright © 2019 Royal Icing. All rights reserved.
//

import SwiftUI
import UIKit

class CustomSliderCoordinator: NSObject {
    var setFloatValue: (_ value: Float) -> ()

    init(setFloatValue: @escaping (_ value: Float) -> ()) {
        self.setFloatValue = setFloatValue
    }
    
    @IBAction func changed(_ sender: UISlider) {
        setFloatValue(sender.value)
    }
}

struct CustomSlider<FloatType: BinaryFloatingPoint> : UIViewRepresentable {
    typealias UIViewType = UISlider
    
    @Binding var value: FloatType
    var from, through: FloatType
    var minimumTrackTintColor: UIColor?
    var maximumTrackTintColor: UIColor?
    
    func makeCoordinator() -> CustomSliderCoordinator {
        Coordinator(setFloatValue: self.setFloatValue)
    }
    
    func setFloatValue(_ value: Float) {
        self.$value.value = FloatType(value)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomSlider>) -> UISlider {
        let slider = UISlider()
        
        slider.value = Float(value)
        slider.minimumValue = Float(from)
        slider.maximumValue = Float(through)
        
        slider.addTarget(context.coordinator, action: #selector(Coordinator.changed), for: .valueChanged)
        
        return slider
    }
    
    func updateUIView(_ slider: UISlider, context: UIViewRepresentableContext<CustomSlider>) {
        slider.value = Float(value)
        slider.minimumValue = Float(from)
        slider.maximumValue = Float(through)
        
        if let minimumTrackTintColor = self.minimumTrackTintColor {
            slider.minimumTrackTintColor = minimumTrackTintColor
        }
        
        if let maximumTrackTintColor = self.maximumTrackTintColor {
            slider.maximumTrackTintColor = maximumTrackTintColor
        }
    }
}

extension CustomSlider {
    func trackColors(min: UIColor?, max: UIColor?) -> CustomSlider {
        var copy = self
        if let min = min { copy.minimumTrackTintColor = min }
        if let max = max { copy.maximumTrackTintColor = max }
        return copy
    }
}
