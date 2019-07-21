//
//  ContentView.swift
//  ImbueSwiftUI
//
//  Created by Patrick Smith on 21/6/19.
//  Copyright © 2019 Royal Icing. All rights reserved.
//

import SwiftUI

struct ValueControl : View {
    var label: String
    var boundValue: Binding<CGFloat>
    var min: CGFloat
    var max: CGFloat
    var places: Int

    var value: CGFloat { boundValue.value }

    var body: some View {
        HStack {
            Text(label).bold()
            Slider(value: boundValue, from: min, through: max)
            Text(String(format: "%.\(places)f", value))
                .frame(width: 60, height: nil, alignment: .trailing)
        }
    }
}

struct MakeSection : View {
    @State var color = ColorValue.labD50(ColorValue.Lab(l: 50, a: 0, b: 0))

    var srgbColor: ColorValue.RGB {
        color.srgb
    }

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                color.swiftUIColor
                ColorValue.sRGB(srgbColor).swiftUIColor
            }
            Section {
                ValueControl(label: "L", boundValue: $color[keyPath: \.lab.l], min: 0, max: 100, places: 0)
                ValueControl(label: "a", boundValue: $color[keyPath: \.lab.a], min: -128, max: 127, places: 0)
                ValueControl(label: "b", boundValue: $color[keyPath: \.lab.b], min: -128, max: 127, places: 0)
                ValueControl(label: "R", boundValue: $color[keyPath: \.srgb.r], min: 0, max: 1, places: 3)
                ValueControl(label: "G", boundValue: $color[keyPath: \.srgb.g], min: 0, max: 1, places: 3)
                ValueControl(label: "B", boundValue: $color[keyPath: \.srgb.b], min: 0, max: 1, places: 3)
            }.padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
//            Spacer()
        }
    }
}
//
struct AdjustmentSection : View {
    @State var color: ColorValue = ColorValue.labD50(ColorValue.Lab(l: 50, a: 0, b: 0))
    @State var lightenAmount: CGFloat = 0.0
    @State var darkenAmount: CGFloat = 0.0
    @State var desaturateAmount: CGFloat = 0.0
    @State var invert: Bool = false

    private enum Step : Int {
        case lighten = 0
        case darken
        case desaturate
        case invert
    }

    private func transform(color: ColorValue, upTo: Step) -> ColorValue {
        var rgb = color.toSRGB()!
        for step in 0 ... upTo.rawValue {
            switch step {
            case Step.lighten.rawValue:
                rgb = rgb.lightened(amount: self.lightenAmount)
            case Step.darken.rawValue:
                rgb = rgb.darkened(amount: self.darkenAmount)
            case Step.desaturate.rawValue:
                rgb = rgb.desaturated(amount: self.desaturateAmount)
            case Step.invert.rawValue:
                if self.invert {
                    rgb = rgb.inverted()
                }
            default:
                break
            }
        }
        return ColorValue.sRGB(rgb)
    }

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                transform(color: color, upTo: .invert).swiftUIColor?.layoutPriority(1).edgesIgnoringSafeArea(.top)
            }
            Section {
                ValueControl(label: "Lighten", boundValue: $lightenAmount, min: 0, max: 1, places: 3)
                ValueControl(label: "Darken", boundValue: $darkenAmount, min: 0, max: 1, places: 3)
                ValueControl(label: "Desaturate", boundValue: $desaturateAmount, min: 0, max: 1, places: 3)
                Toggle(isOn: $invert) {
                    Text("Invert").bold()
                }
            }
                .layoutPriority(0)
                .padding(EdgeInsets(top: 4, leading: 16, bottom: 8, trailing: 16))
//                        Spacer()
        }
    }
}

struct ContentView : View {
    enum Section : String, CaseIterable {
        case make
        case adjust
    }
    
    @State var section: Section = .make
    
    var body: some View {
        TabbedView(selection: $section.caseIndex) {
            MakeSection()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Make")
            }
            .tag(0)
            AdjustmentSection()
                .tabItem {
                    Image(systemName: "dial.fill")
                    Text("Adjust").font(.title)
            }
            .tag(1)
        }.edgesIgnoringSafeArea(.top)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(section: .make)
                .colorScheme(.light)
            ContentView(section: .make)
                .colorScheme(.dark)
            ContentView(section: .adjust)
                .colorScheme(.light)
            ContentView(section: .adjust)
                .colorScheme(.dark)
        }
    }
}
#endif
