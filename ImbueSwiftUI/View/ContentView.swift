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
    @ObjectBinding var instance = AdjustableColorInstance(state: .init())
    
    var colorPreview: some View {
        let color = instance.state.inputColor
        
        return HStack(alignment: .center, spacing: 0) {
            color.swiftUIColor
            ColorValue.sRGB(color.srgb).swiftUIColor
        }
    }

    var body: some View {
        let colorBinding = $instance.state.inputColor
        
        return VStack {
            self.colorPreview
            Section {
                ValueControl(label: "L", boundValue: colorBinding[keyPath: \.lab.l], min: 0, max: 100, places: 0)
                ValueControl(label: "a", boundValue: colorBinding[keyPath: \.lab.a], min: -128, max: 127, places: 0)
                ValueControl(label: "b", boundValue: colorBinding[keyPath: \.lab.b], min: -128, max: 127, places: 0)
                ValueControl(label: "R", boundValue: colorBinding[keyPath: \.srgb.r], min: 0, max: 1, places: 3)
                ValueControl(label: "G", boundValue: colorBinding[keyPath: \.srgb.g], min: 0, max: 1, places: 3)
                ValueControl(label: "B", boundValue: colorBinding[keyPath: \.srgb.b], min: 0, max: 1, places: 3)
            }.padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
//            Spacer()
        }
    }
}
//
struct AdjustmentSection : View {
    @ObjectBinding var instance = AdjustableColorInstance(state: .init())

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                instance.outputColor.swiftUIColor?.layoutPriority(1).edgesIgnoringSafeArea(.top)
            }
            Section {
                ValueControl(label: "Lighten", boundValue: $instance.state.lightenAmount, min: 0, max: 1, places: 3)
                ValueControl(label: "Darken", boundValue: $instance.state.darkenAmount, min: 0, max: 1, places: 3)
                ValueControl(label: "Desaturate", boundValue: $instance.state.desaturateAmount, min: 0, max: 1, places: 3)
                Toggle(isOn: $instance.state.invert) {
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
    @ObjectBinding var instance = AdjustableColorInstance(state: .init())
    
    enum Section : String, CaseIterable {
        case make
        case adjust
    }
    
    @State var section: Section = .make
    
    var body: some View {
        TabbedView(selection: $section.caseIndex) {
            MakeSection(instance: instance)
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Make")
            }
            .tag(0)
            AdjustmentSection(instance: instance)
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
