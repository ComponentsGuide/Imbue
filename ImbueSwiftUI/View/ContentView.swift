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
            CustomSlider(value: boundValue, from: min, through: max)
            Slider(value: boundValue, in: min...max)
            Text(String(format: "%.\(places)f", value))
                .frame(width: CGFloat(60), height: nil, alignment: .trailing)
        }
    }
}

struct SavedColor: Identifiable {
    var id: UUID
    var colorValue: ColorValue
}

struct MakeSection : View {
    @ObjectBinding var instance = AdjustableColorInstance(state: .init())
    
    @State var savedColors: [SavedColor] = []
    
    @State var editHex = false
    
    func addCurrentColor() {
        savedColors.append(.init(id: UUID(), colorValue: instance.state.inputColor))
    }
    
    var colorPreview: some View {
        let color = instance.state.inputColor
        
        return VStack(alignment: .center, spacing: 0) {
            ForEach(savedColors) { savedColor in
                Button(action: {
                    self.instance.state.inputColor = savedColor.colorValue
                }) {
                    savedColor.colorValue.swiftUIColor
                }
            }
            /*.onMove { (indexes, toIndex) in
                self.savedColors.move(fromOffsets: indexes, toOffset: toIndex)
            }*/
            Divider().background(Color.black)
            HStack(alignment: .center, spacing: 0) {
                color.swiftUIColor // Wide
                ColorValue.sRGB(color.srgb).swiftUIColor // sRGB
            }
        }.edgesIgnoringSafeArea(.top)
    }
    
    var actions: some View {
        HStack {
            Button(action: {
                self.instance.state.inputColor.copy(to: .general)
            }, label: { Image(systemName: "doc.on.doc") })
                .accessibility(label: Text("Copy"))
            
            Button(action: {
                guard let newColor = ColorValue(pasteboard: .general)
                    else { return }
                
                self.instance.state.inputColor = newColor
            }, label: {
                    Image(systemName: "doc.on.clipboard")
            })
                .accessibility(label: Text("Paste"))
            
            TextField("Hex", text: $instance.state[\.inputColor.srgb.hexString])
            
            Button(action: {
                withAnimation {
                    self.addCurrentColor()
                }
            }, label: { Image(systemName: "plus.circle") })
                .accessibility(label: Text("Add"))
        }.padding(EdgeInsets(top: 4.0, leading: 12.0, bottom: 4.0, trailing: 12.0))
    }
    
    var body: some View {
        let colorBinding = $instance.state.inputColor
        
        return VStack {
            self.colorPreview
            self.actions
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
                instance.outputColor.swiftUIColor.layoutPriority(1).edgesIgnoringSafeArea(.top)
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
        TabView(selection: $section.caseIndex) {
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
        .accentColor(.init(.sRGB, white: 0.2, opacity: 1.0))
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
