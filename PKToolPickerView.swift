//
//  PKToolPickerView.swift
//  noteE
//
//  Created by 张旭晟 on 2023/4/1.
//

import SwiftUI

class PKToolPickerManage: ObservableObject {
    @Published var PKToolSlect:ToolType = .Pen
    
    @Published var PenWidth:CGFloat = 2.7
    @Published var PenColor:CodableColor = CodableColor(.black)
    @Published var PenAlpha:Double = 1
    
    @Published var PencilWidth:CGFloat = 5.8
    @Published var PencilColor:CodableColor = CodableColor(UIColor(red: 0.475, green: 0.831, blue: 0.459, alpha: 1))
    @Published var PencilAlpha:Double = 0.5
    
    @Published var MarkerWidth:CGFloat = 20.6
    @Published var MarkerColor:CodableColor = CodableColor(UIColor(red: 0.969, green: 0.824, blue: 0.329, alpha: 1))
    @Published var MarkerAlpha:Double = 0.8
    
    @Published var EraserisFull = false
    
    @Published var isRuler = false
    
    @Published var showColorPicker = false
    @Published var LastPicker:ToolType?
    @Published var LastPicker2:ToolType = .Pen
    @Published var LastPicker3:ToolType = .Pen
    
    @Published var PenControl = false
    @Published var PencilControl = false
    @Published var MarkerControl = false
    @Published var EraserControl = false
}
enum ToolType:Hashable, Equatable, Codable {
    case Pen
    case Marker
    case Pencil
    case Lasso
    case Eraser
}

struct ToolSlectCodable: Codable {
    var PKToolSlect:ToolType = .Pen
    
    var PenWidth:CGFloat = 2.7
    var PenColor:CodableColor = CodableColor(.black)
    var PenAlpha:Double = 1
    
    var PencilWidth:CGFloat = 5.8
    var PencilColor:CodableColor = CodableColor(UIColor(red: 0.475, green: 0.831, blue: 0.459, alpha: 1))
    var PencilAlpha:Double = 0.5
    
    var MarkerWidth:CGFloat = 20.6
    var MarkerColor:CodableColor = CodableColor(UIColor(red: 0.969, green: 0.824, blue: 0.329, alpha: 1))
    var MarkerAlpha:Double = 0.8
    
    var EraserisFull = false
    
    var isRuler = false
    
    var nedAlignmentOffset:BarAlignment = .bottom
}

enum BarAlignment:Hashable, Equatable, Codable {
    case leading
    case trailing
    case top
    case bottom
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
}


struct PKToolPickerView: View {
    @ObservedObject var manage:PKToolPickerManage
    
    @State var Ofset:CGPoint = .zero
    @GestureState var isDrag = false
    @State var isDrag2 = false
    @State var nedAlignmentOffset:BarAlignment = .bottom
    @State var setAlignment = false
    @State var setRad = false
    
    @State var Bar = true
    @State var AlignmentsetRad:Double = 0
    
   
    func DragSet(GeometryProxy: GeometryProxy) {
        if Ofset.x <= GeometryProxy.size.width * (2 / 3), Ofset.x >= GeometryProxy.size.width * (1 / 3) {
            if Ofset.y <= GeometryProxy.size.height * (5 / 12) {
                Bar = true
                nedAlignmentOffset = .top
            } else if Ofset.y >= GeometryProxy.size.height * (7 / 12) {
                Bar = true
                nedAlignmentOffset = .bottom
            } else {
                if Ofset.x <= GeometryProxy.size.width / 2 {
                    Bar = true
                    nedAlignmentOffset = .leading
                } else {
                    Bar = true
                    nedAlignmentOffset = .trailing
                }
            }
        } else if Ofset.x >= GeometryProxy.size.width * (2 / 3) {
            if Ofset.y >= GeometryProxy.size.height * (1 / 3),  Ofset.y <= GeometryProxy.size.height * (2 / 3){
                Bar = true
                nedAlignmentOffset = .trailing
            } else if Ofset.y <= GeometryProxy.size.height * (1 / 3) {
                Bar = false
                nedAlignmentOffset = .topTrailing
            } else {
                Bar = false
                nedAlignmentOffset = .bottomTrailing
            }
        } else {
            if Ofset.y >= GeometryProxy.size.height * (1 / 3),  Ofset.y <= GeometryProxy.size.height * (2 / 3){
                Bar = true
                nedAlignmentOffset = .leading
            } else if Ofset.y <= GeometryProxy.size.height * (1 / 3) {
                Bar = false
                nedAlignmentOffset = .topLeading
            } else {
                Bar = false
                nedAlignmentOffset = .bottomLeading
            }
        }
        setRad.toggle()
    }
    
    func maxWidth() -> CGFloat {
        if AlignmentsetRad == .pi / 2 || AlignmentsetRad == -(.pi / 2) {
            if Bar || isDrag {
                return 100
            } else {
                return 80
            }
        } else {
            if Bar {
                if isDrag {
                    return 100
                } else {
                    return 500
                }
            } else {
                if isDrag {
                    return 100
                } else {
                    return 80
                }
            }
        }
    }
    
    func maxHeight() -> CGFloat {
        if AlignmentsetRad == .pi / 2 || AlignmentsetRad == -(.pi / 2) {
            if Bar {
                if isDrag {
                    return 100
                } else {
                    return 500
                }
            } else {
                if isDrag {
                    return 100
                } else {
                    return 80
                }
            }
        } else {
            if Bar || isDrag {
                return 100
            } else {
                return 80
            }
        }
    }
    
    func ifDragBar(_ action:@escaping () -> Void) {
        if !isDrag && Bar {
            mainAsyns {
                action()
            }
        } else {
            mainAsyns {
                switch nedAlignmentOffset {
                case .top:
                    return
                case .topLeading:
                    nedAlignmentOffset = .top
                case .topTrailing:
                    nedAlignmentOffset = .top
                case .bottom:
                    return
                case .bottomLeading:
                    nedAlignmentOffset = .bottom
                case .bottomTrailing:
                    nedAlignmentOffset = .bottom
                case .leading:
                    return
                case .trailing:
                    return
                }
                setRad.toggle()
                setAlignment.toggle()
                Bar = true
            }
        }
    }
    
    
    
    @ViewBuilder
    func BarView(GeometryProxy: SwiftUI.GeometryProxy) -> some View {
        if !isDrag && Bar {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        ZStack {
            if (!isDrag && Bar) || ((isDrag || !Bar) && manage.PKToolSlect == .Pen) {
                Pen(color: manage.PenColor, Width: manage.PenWidth, alpha: manage.PenAlpha)
                    .offset(x: 0, y: manage.PKToolSlect == .Pen ? 1 : 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    
            }
        }
        .contentShape(Rectangle())
            .onTapGesture {
                ifDragBar {
                    manage.LastPicker2 = manage.PKToolSlect
                    manage.LastPicker = nil
                    if manage.PKToolSlect != .Pen {
                        manage.PKToolSlect = .Pen
                    } else {
                        manage.PenControl.toggle()
                    }
                }
            }
            .Popover(isPresented: $manage.PenControl) {
                ItemWidthSetting(Width: $manage.PenWidth, color: $manage.PenColor, widthin: 0.9...25.7, width1: 0.9, width2: 2.7, width3: 5.3, width4: 11, width5: 25.7, type: "Pen")
            }
        
        ZStack {
            if (!isDrag && Bar) || ((isDrag || !Bar) && manage.PKToolSlect == .Pencil) {
                Pencil(color: manage.PencilColor, Width: manage.PencilWidth, alpha: manage.PencilAlpha)
                    .offset(x: 0, y: manage.PKToolSlect == .Pencil ? 1 : 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            ifDragBar {
                manage.LastPicker2 = manage.PKToolSlect
                manage.LastPicker = nil
                if manage.PKToolSlect != .Pencil {
                    manage.PKToolSlect = .Pencil
                } else {
                    manage.PencilControl.toggle()
                }
            }
        }
        .Popover(isPresented: $manage.PencilControl) {
            ItemWidthSetting(Width: $manage.PencilWidth, color: $manage.PencilColor, widthin: 2.4...16, width1: 2.4, width2: 5.8, width3: 9.2, width4: 12.6, width5: 16, type: "Pencil")
        }
        
        ZStack {
            if (!isDrag && Bar) || ((isDrag || !Bar) && manage.PKToolSlect == .Marker) {
                Marker(color: manage.MarkerColor, Width: manage.MarkerWidth, alpha: manage.MarkerAlpha )
                    .offset(x: 0, y: manage.PKToolSlect == .Marker ? 1 : 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                   
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            ifDragBar {
                manage.LastPicker2 = manage.PKToolSlect
                manage.LastPicker = nil
                if manage.PKToolSlect != .Marker {
                    manage.PKToolSlect = .Marker
                } else {
                    manage.MarkerControl.toggle()
                }
            }
        }
        .Popover(isPresented: $manage.MarkerControl) {
            ItemWidthSetting(Width: $manage.MarkerWidth, color: $manage.MarkerColor, widthin: 7.5...60, width1: 7.5, width2: 20.6, width3: 33.8, width4: 46.9, width5: 60, type: "Marker")
        }
        
        ZStack {
            if (!isDrag && Bar) || ((isDrag || !Bar) && manage.PKToolSlect == .Eraser) {
                Eraser(isFull: manage.EraserisFull)
                    .offset(x: 0, y: manage.PKToolSlect == .Eraser ? 6 : 26)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            ifDragBar {
                manage.LastPicker2 = manage.PKToolSlect
                manage.LastPicker = nil
                if manage.PKToolSlect != .Eraser {
                    manage.PKToolSlect = .Eraser
                } else {
                    manage.EraserControl.toggle()
                }
            }
        }
        .Popover(isPresented: $manage.EraserControl) {
            HStack {
                Eraser(isFull: false)
                    .offset(y: !manage.EraserisFull ? 26 : 36)
                    .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        manage.EraserisFull = false
                    }
                
                Eraser(isFull: true)
                    .offset(y: manage.EraserisFull ? 26 : 36)
                    .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        manage.EraserisFull = true
                    }
            }
            .animation(.spring(dampingFraction: 0.6).speed(2), value: manage.EraserisFull)
            .clipShape(Rectangle())
            .padding(.top, 15)
            .frame(width: 100)
        }
        
        ZStack {
            if (!isDrag && Bar) || ((isDrag || !Bar) && manage.PKToolSlect == .Lasso) {
                Lasso()
                    .offset(x: 0, y: manage.PKToolSlect == .Lasso ? 6 : 26)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            ifDragBar {
                manage.LastPicker2 = manage.PKToolSlect
                manage.LastPicker = nil
                manage.PKToolSlect = .Lasso
            }
        }
        ZStack {
            if !isDrag && Bar {
                Ruler()
                    .offset(x: 0, y: manage.isRuler ? 6 : 26)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            mainAsyns {
                manage.isRuler.toggle()
            }
        }
        
        if !isDrag && Bar {
            VStack {
                if GeometryProxy.size.width > 500 {
                    HStack {
                        ColorButton(color: .black)
                        ColorButton(color: .blue)
                        ColorButton(color: UIColor(red: 0.475, green: 0.831, blue: 0.459, alpha: 1))
                    }
                }
                
                HStack {
                    if GeometryProxy.size.width > 500 {
                        ColorButton(color: UIColor(red: 0.969, green: 0.824, blue: 0.329, alpha: 1))
                        ColorButton(color: .red)
                    }
                    ColorPickerButton()
                }
            }
            .frame(minHeight: 100 , maxHeight: 100)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.leading, 10)
            
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    @AppStorage("CodableTool") var CodableTool:Data = Data()
    @State var fistShow = true
    var body: some View {
        GeometryReader { GeometryProxy in
            Color("fuckcolor")
                .onTapGesture {
                    ifDragBar { }
                }
                .overlay {
                    HStack {
                        BarView(GeometryProxy: GeometryProxy)
                    }
                    .clipShape(Rectangle())
                    .frame(width: 500, height: 100)
                    .scaleEffect(x: Bar ? 1 : (isDrag ? 1 : 0.8), y: Bar ? 1 : (isDrag ? 1 : 0.8), anchor: .bottom)
                    .scaleEffect(x: min(1, GeometryProxy.size.width / 500), y: min(1, GeometryProxy.size.width / 500), anchor: .bottom)
                    .rotationEffect(Angle(radians: isDrag2 ? 0 : AlignmentsetRad))
                    .buttonStyle(nilStyle())
                }
                .frame(maxWidth:maxWidth(), maxHeight: maxHeight())
                .clipShape(Capsule(style: (isDrag || !Bar) ? RoundedCornerStyle.circular : .continuous))
                .ifMode { AnyView in
                    #if targetEnvironment(macCatalyst)
                        AnyView
                        .compositingGroup()
                        .drawingGroup()
                    #else
                    if #available(iOS 16.4, *) {
                        AnyView
                            .compositingGroup()
                            .drawingGroup()
                    } else {
                        AnyView
                    }
                    #endif
                }
                .background {
                    PencilDouble()
                }
                .background {
                    if isDrag || !Bar {
                        ColorPickerButton()
                            .opacity(0.01)
                    }
                }
                .shadow(radius: 8)
                .padding([.leading, .trailing], Bar ? 20 : 0)
                .position(Ofset)
                .highPriorityGesture(
                    DragGesture()
                        .updating($isDrag){ Value, State, Transaction in
                            State = true
                            mainAsyns {
                                Ofset = Value.location
                                DragSet(GeometryProxy: GeometryProxy)
                            }
                        }
                )
            
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
                .animation(.spring(), value: isDrag)
                .animation(fistShow ? nil : .spring(), value: Bar)
                .animation(.spring(dampingFraction: 0.6).speed(2), value: manage.PKToolSlect)
                .animation(.spring(dampingFraction: 0.6).speed(2), value: manage.isRuler)
            
                .onChange(of: isDrag) { newValue in
                    if isDrag {
                        withAnimation(.spring()) {
                            isDrag2 = isDrag
                        }
                    } else {
                        isDrag2 = isDrag
                        setAlignment.toggle()
                    }
                }
                .onChange(of: GeometryProxy.size) { newValue in
                    setAlignment.toggle()
                }
                .onChange(of: setAlignment) { newValue in
                    mainAsyns {
                        withAnimation(.spring()) {
                            switch nedAlignmentOffset {
                            case .top:
                                Bar = true
                                Ofset = CGPoint(x: GeometryProxy.size.width / 2, y: 50)
                            case .topLeading:
                                Bar = false
                                Ofset = CGPoint(x: 70, y: 50)
                            case .topTrailing:
                                Bar = false
                                Ofset = CGPoint(x: GeometryProxy.size.width - 70, y: 50)
                            case .bottom:
                                Bar = true
                                Ofset = CGPoint(x: GeometryProxy.size.width / 2, y: GeometryProxy.size.height - 50)
                            case .bottomLeading:
                                Bar = false
                                Ofset = CGPoint(x: 70, y: GeometryProxy.size.height - 50)
                            case .bottomTrailing:
                                Bar = false
                                Ofset = CGPoint(x: GeometryProxy.size.width - 70, y: GeometryProxy.size.height - 50)
                            case .leading:
                                Bar = true
                                Ofset = CGPoint(x: 70, y: GeometryProxy.size.height / 2)
                            case .trailing:
                                Bar = true
                                Ofset = CGPoint(x: GeometryProxy.size.width - 70, y: GeometryProxy.size.height / 2)
                            }
                        }
                    }
                }
                .onChange(of: setRad) { newValue in
                    switch nedAlignmentOffset {
                    case .top:
                        AlignmentsetRad = 0
                    case .topLeading:
                        AlignmentsetRad = 0
                    case .topTrailing:
                        AlignmentsetRad = 0
                    case .bottom:
                        AlignmentsetRad = 0
                    case .bottomLeading:
                        AlignmentsetRad = 0
                    case .bottomTrailing:
                        AlignmentsetRad = 0
                    case .leading:
                        AlignmentsetRad = .pi / 2
                    case .trailing:
                        AlignmentsetRad = -(.pi / 2)
                    }
                }
                .onAppear {
                    if CodableTool != Data() {
                        AutoDo {
                            let jsdd = try JSONDecoder().decode(ToolSlectCodable.self, from: CodableTool)
                            manage.PKToolSlect = jsdd.PKToolSlect
                            manage.PenWidth = jsdd.PenWidth
                            manage.PenColor = jsdd.PenColor
                            manage.PenAlpha = jsdd.PenAlpha
                            manage.PencilWidth = jsdd.PencilWidth
                            manage.PencilColor = jsdd.PencilColor
                            manage.PencilAlpha = jsdd.PencilAlpha
                            manage.MarkerWidth = jsdd.MarkerWidth
                            manage.MarkerColor = jsdd.MarkerColor
                            manage.MarkerAlpha = jsdd.MarkerAlpha
                            manage.EraserisFull = jsdd.EraserisFull
                            manage.isRuler = jsdd.isRuler
                            nedAlignmentOffset = jsdd.nedAlignmentOffset
                            switch nedAlignmentOffset {
                            case .top:
                                Bar = true
                                Ofset = CGPoint(x: GeometryProxy.size.width / 2, y: 50)
                            case .topLeading:
                                Bar = false
                                Ofset = CGPoint(x: 70, y: 50)
                            case .topTrailing:
                                Bar = false
                                Ofset = CGPoint(x: GeometryProxy.size.width - 70, y: 50)
                            case .bottom:
                                Bar = true
                                Ofset = CGPoint(x: GeometryProxy.size.width / 2, y: GeometryProxy.size.height - 50)
                            case .bottomLeading:
                                Bar = false
                                Ofset = CGPoint(x: 70, y: GeometryProxy.size.height - 50)
                            case .bottomTrailing:
                                Bar = false
                                Ofset = CGPoint(x: GeometryProxy.size.width - 70, y: GeometryProxy.size.height - 50)
                            case .leading:
                                Bar = true
                                Ofset = CGPoint(x: 70, y: GeometryProxy.size.height / 2)
                            case .trailing:
                                Bar = true
                                Ofset = CGPoint(x: GeometryProxy.size.width - 70, y: GeometryProxy.size.height / 2)
                            }
                            switch nedAlignmentOffset {
                            case .top:
                                AlignmentsetRad = 0
                            case .topLeading:
                                AlignmentsetRad = 0
                            case .topTrailing:
                                AlignmentsetRad = 0
                            case .bottom:
                                AlignmentsetRad = 0
                            case .bottomLeading:
                                AlignmentsetRad = 0
                            case .bottomTrailing:
                                AlignmentsetRad = 0
                            case .leading:
                                AlignmentsetRad = .pi / 2
                            case .trailing:
                                AlignmentsetRad = -(.pi / 2)
                            }
                            mainAsyns(0.3) {
                                fistShow = false
                            }
                        }
                    } else {
                        switch nedAlignmentOffset {
                        case .top:
                            Bar = true
                            Ofset = CGPoint(x: GeometryProxy.size.width / 2, y: 50)
                        case .topLeading:
                            Bar = false
                            Ofset = CGPoint(x: 70, y: 50)
                        case .topTrailing:
                            Bar = false
                            Ofset = CGPoint(x: GeometryProxy.size.width - 70, y: 50)
                        case .bottom:
                            Bar = true
                            Ofset = CGPoint(x: GeometryProxy.size.width / 2, y: GeometryProxy.size.height - 50)
                        case .bottomLeading:
                            Bar = false
                            Ofset = CGPoint(x: 70, y: GeometryProxy.size.height - 50)
                        case .bottomTrailing:
                            Bar = false
                            Ofset = CGPoint(x: GeometryProxy.size.width - 70, y: GeometryProxy.size.height - 50)
                        case .leading:
                            Bar = true
                            Ofset = CGPoint(x: 70, y: GeometryProxy.size.height / 2)
                        case .trailing:
                            Bar = true
                            Ofset = CGPoint(x: GeometryProxy.size.width - 70, y: GeometryProxy.size.height / 2)
                        }
                        switch nedAlignmentOffset {
                        case .top:
                            AlignmentsetRad = 0
                        case .topLeading:
                            AlignmentsetRad = 0
                        case .topTrailing:
                            AlignmentsetRad = 0
                        case .bottom:
                            AlignmentsetRad = 0
                        case .bottomLeading:
                            AlignmentsetRad = 0
                        case .bottomTrailing:
                            AlignmentsetRad = 0
                        case .leading:
                            AlignmentsetRad = .pi / 2
                        case .trailing:
                            AlignmentsetRad = -(.pi / 2)
                        }
                    }
                }
                .onDisappear {
                    AutoDo {
                        let jsdd = ToolSlectCodable(PKToolSlect: manage.PKToolSlect, PenWidth: manage.PenWidth, PenColor: manage.PenColor, PenAlpha: manage.PenAlpha, PencilWidth: manage.PencilWidth, PencilColor: manage.PencilColor, PencilAlpha: manage.PencilAlpha, MarkerWidth: manage.MarkerWidth, MarkerColor: manage.MarkerColor, MarkerAlpha: manage.MarkerAlpha, EraserisFull: manage.EraserisFull, isRuler: manage.isRuler, nedAlignmentOffset: nedAlignmentOffset)
                        CodableTool = try JSONEncoder().encode(jsdd)
                    }
                }
        }
        .environmentObject(manage)
    }
    
    func ColorButton(color:UIColor) -> some View {
        Button {
            switch manage.PKToolSlect {
            case .Pen:
                manage.PenColor = CodableColor(color)
            case .Marker:
                manage.MarkerColor = CodableColor(color)
            case .Pencil:
                manage.PencilColor = CodableColor(color)
            case .Lasso:
                return
            case .Eraser:
                return
            }
        } label: {
            Color(color)
                .clipShape(Circle())
                .overlay {
                    switch manage.PKToolSlect {
                    case .Pen:
                        if manage.PenColor.UIColor == color {
                            Circle()
                                .stroke(lineWidth: 2)
                                .foregroundColor(.white)
                                .padding(.all, 3)
                        }
                    case .Marker:
                        if manage.MarkerColor.UIColor == color {
                            Circle()
                                .stroke(lineWidth: 2)
                                .foregroundColor(.white)
                                .padding(.all, 3)
                        }
                    case .Pencil:
                        if manage.PencilColor.UIColor == color {
                            Circle()
                                .stroke(lineWidth: 2)
                                .foregroundColor(.white)
                                .padding(.all, 3)
                        }
                    case .Lasso:
                        EmptyView()
                    case .Eraser:
                        EmptyView()
                    }
                }
                .frame(width: 30, height: 30)
        }
    }
    
    func ColorPickerButton() -> some View {
        let Colors:[UIColor] = [.black, .blue, UIColor(red: 0.475, green: 0.831, blue: 0.459, alpha: 1), UIColor(red: 0.969, green: 0.824, blue: 0.329, alpha: 1), .red]
        return Button {
            switch manage.PKToolSlect {
            case .Pen:
                manage.showColorPicker.toggle()
            case .Marker:
                manage.showColorPicker.toggle()
            case .Pencil:
                manage.showColorPicker.toggle()
            case .Lasso:
                return
            case .Eraser:
                return
            }
        } label: {
            Image("ColorPickerButton")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .overlay {
                    switch manage.PKToolSlect {
                    case .Pen:
                        if !Colors.contains(manage.PenColor.UIColor) {
                            Circle()
                                .foregroundColor(Color(manage.PenColor.UIColor))
                                .padding(.all, 5)
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.white)
                                        .padding(.all, 4)
                                }
                        }
                    case .Marker:
                        if !Colors.contains(manage.MarkerColor.UIColor) {
                            Circle()
                                .foregroundColor(Color(manage.MarkerColor.UIColor))
                                .padding(.all, 5)
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.white)
                                        .padding(.all, 4)
                                }
                        }
                    case .Pencil:
                        if !Colors.contains(manage.PencilColor.UIColor) {
                            Circle()
                                .foregroundColor(Color(manage.PencilColor.UIColor))
                                .padding(.all, 5)
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.white)
                                        .padding(.all, 4)
                                }
                        }
                    case .Lasso:
                        EmptyView()
                    case .Eraser:
                        EmptyView()
                    }
                    
                }
                .frame(width: 30, height: 30)
        }
        .Popover(isPresented: $manage.showColorPicker) {
            Group {
                switch manage.PKToolSlect {
                case .Pen:
                    ColorPicker(colors: manage.PenColor.UIColor.withAlphaComponent(manage.PenAlpha)) { CGColor in
                        manage.PenColor = CodableColor(UIColor(cgColor: CGColor).withAlphaComponent(1))
                        manage.PenAlpha = CGColor.alpha
                    }
                case .Marker:
                    ColorPicker(colors: manage.MarkerColor.UIColor.withAlphaComponent(manage.MarkerAlpha)) { CGColor in
                        manage.MarkerColor = CodableColor(UIColor(cgColor: CGColor).withAlphaComponent(1))
                        manage.MarkerAlpha = CGColor.alpha
                    }
                case .Pencil:
                    ColorPicker(colors: manage.PencilColor.UIColor.withAlphaComponent(manage.PencilAlpha)) { CGColor in
                        manage.PencilColor = CodableColor(UIColor(cgColor: CGColor).withAlphaComponent(1))
                        manage.PencilAlpha = CGColor.alpha
                    }
                case .Lasso:
                    EmptyView()
                case .Eraser:
                    EmptyView()
                }
            }
            .frame(idealWidth: 300, idealHeight: 550)
        }
    }
}

struct PencilDouble:UIViewRepresentable {
    typealias UIViewType = UIView
    @EnvironmentObject var manage:PKToolPickerManage
    
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let pencilInteraction = UIPencilInteraction()
        pencilInteraction.delegate = context.coordinator
        view.addInteraction(pencilInteraction)
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    func makeCoordinator() -> coordinator {
        coordinator(RootView: self)
    }
    
    class coordinator:NSObject, UIPencilInteractionDelegate {
        let RootView: PencilDouble
        
        init(RootView: PencilDouble) {
            self.RootView = RootView
        }
        func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
            switch UIPencilInteraction.preferredTapAction {
            case .ignore:
                return
            case .switchEraser:
                if RootView.manage.PKToolSlect == .Eraser, RootView.manage.LastPicker != nil {
                    RootView.manage.PKToolSlect = RootView.manage.LastPicker!
                } else {
                    RootView.manage.LastPicker = RootView.manage.PKToolSlect
                    RootView.manage.PKToolSlect = .Eraser
                }
            case .switchPrevious:
                if RootView.manage.PKToolSlect == RootView.manage.LastPicker2 {
                    RootView.manage.PKToolSlect = RootView.manage.LastPicker3
                } else {
                    RootView.manage.LastPicker3 = RootView.manage.PKToolSlect
                    RootView.manage.PKToolSlect = RootView.manage.LastPicker2
                }
            case .showColorPalette:
                switch RootView.manage.PKToolSlect {
                case .Pen:
                    RootView.manage.showColorPicker.toggle()
                case .Marker:
                    RootView.manage.showColorPicker.toggle()
                case .Pencil:
                    RootView.manage.showColorPicker.toggle()
                case .Lasso:
                    return
                case .Eraser:
                    return
                }
            case .showInkAttributes:
                switch RootView.manage.PKToolSlect {
                case .Pen:
                    RootView.manage.PenControl.toggle()
                case .Marker:
                    RootView.manage.MarkerControl.toggle()
                case .Pencil:
                    RootView.manage.PencilControl.toggle()
                case .Lasso:
                    return
                case .Eraser:
                    RootView.manage.EraserControl.toggle()
                }
            @unknown default:
                return
            }
        }
    }
}

func Pen(color:CodableColor, Width: CGFloat, alpha: Double) -> some View {
    return VStack {
        Spacer()
        ZStack(alignment: .top) {
            Image("PenBack")
                .resizable()
                .scaledToFit()
            Pentop()
                .foregroundColor(Color(color.UIColor))
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 38.83)
                Rectangle()
                    .foregroundColor(Color(color.UIColor))
                    .frame(height: (Width / 3) + 1)
            }
            VStack(spacing: 0) {
                Image("PenShine")
                    .resizable()
                    .scaledToFit()
                Image("PenShine")
                    .resizable()
                    .scaledToFit()
            }
            .mask {
                ZStack(alignment: .top) {
                    Pentop()
                        .foregroundColor(Color(color.UIColor))
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 38.83)
                        Rectangle()
                            .foregroundColor(Color(color.UIColor))
                            .frame(height: (Width / 3) + 1)
                    }
                }
            }
            if alpha < 1 {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 62)
                    Text(String(Int(Double(alpha) * 100)))
                        .font(.system(size: 6))
                        .bold()
                        .foregroundColor(.gray)
                }
            }
        }
    }
    .frame(width: 19, height: 90)
    .compositingGroup()
    .drawingGroup()
    .shadow(color: .gray.opacity(0.5),radius: 3, x: 0, y: 4)
    
    struct Pentop: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(rect.midX - 1, rect.minY + 1))
                path.addQuadCurve(to: CGPoint(rect.midX + 1, rect.minY + 1), control: rect.midXminY)
                path.addLine(to: CGPoint(rect.midX + 3, rect.minY + 10))
                path.addLine(to: CGPoint(rect.midX - 3, rect.minY + 10))
                path.addLine(to:CGPoint(rect.midX - 1, rect.minY + 1))
            }
        }
    }

}

func Pencil(color:CodableColor, Width: CGFloat, alpha: Double) -> some View {
    return VStack {
        Spacer()
        ZStack(alignment: .top) {
            Image("PencilBack")
                .resizable()
                .scaledToFit()
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 2)
                Penciltop()
                    .foregroundColor(Color(color.UIColor))
            }
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 42)
                Rectangle()
                    .foregroundColor(Color(color.UIColor))
                    .frame(height: Width / 2)
            }
            VStack(spacing: 0) {
                Image("PencilShine")
                    .resizable()
                    .scaledToFit()
                Image("PencilShine")
                    .resizable()
                    .scaledToFit()
            }
            .mask {
                ZStack(alignment: .top) {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 2)
                        Penciltop()
                            .foregroundColor(Color(color.UIColor))
                    }
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 42)
                        Rectangle()
                            .foregroundColor(Color(color.UIColor))
                            .frame(height: Width / 2)
                    }
                }
            }
            if alpha < 1 {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 62)
                    Text(String(Int(Double(alpha) * 100)))
                        .font(.system(size: 6))
                        .bold()
                        .foregroundColor(.gray)
                }
            }
        }
    }
    .frame(width: 19, height: 90)
    .compositingGroup()
    .drawingGroup()
    .shadow(color: .gray.opacity(0.5),radius: 3, x: 0, y: 4)
    
    struct Penciltop: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(rect.midX - 1, rect.minY + 1))
                path.addQuadCurve(to: CGPoint(rect.midX + 1, rect.minY + 1), control: rect.midXminY)
                path.addLine(to: CGPoint(rect.midX + 4, rect.minY + 15))
                path.addLine(to: CGPoint(rect.midX - 4, rect.minY + 15))
                path.addLine(to:CGPoint(rect.midX - 1, rect.minY + 1))
            }
        }
    }
}

func Marker(color:CodableColor, Width: CGFloat, alpha: Double) -> some View {
    return VStack {
        Spacer()
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer()
                Image("MarkerBack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 19)
            }
            Markertop()
                .foregroundColor(Color(color.UIColor))
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 40)
                Rectangle()
                    .foregroundColor(Color(color.UIColor))
                    .frame(height: Width / 4)
            }
            VStack(spacing: 0) {
                Image("MarkerShine")
                    .resizable()
                    .scaledToFit()
                Image("MarkerShine")
                    .resizable()
                    .scaledToFit()
            }
            .mask {
                ZStack(alignment: .top) {
                    Markertop()
                        .foregroundColor(Color(color.UIColor))
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 40)
                        Rectangle()
                            .foregroundColor(Color(color.UIColor))
                            .frame(height: Width / 4)
                    }
                }
            }
            if alpha < 1 {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 62)
                    Text(String(Int(Double(alpha) * 100)))
                        .font(.system(size: 6))
                        .bold()
                        .foregroundColor(.gray)
                }
            }
        }
    }
    .frame(width: 19, height: 90)
    .compositingGroup()
    .drawingGroup()
    .shadow(color: .gray.opacity(0.5),radius: 3, x: 0, y: 4)
    
    struct Markertop: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(rect.midX - 5, rect.minY + 6))
                path.addQuadCurve(to: CGPoint(rect.midX - 3, rect.minY + 4), control: CGPoint(rect.midX - 4, rect.minY + 5))
                path.addLine(to: CGPoint(rect.midX + 3, rect.minY + 1))
                path.addQuadCurve(to: CGPoint(rect.midX + 5, rect.minY + 1), control: CGPoint(rect.midX + 4, rect.minY))
                
                path.addLine(to: CGPoint(rect.midX + 5, rect.minY + 10))
                path.addLine(to: CGPoint(rect.midX - 5, rect.minY + 10))
                path.addLine(to: CGPoint(rect.midX - 5, rect.minY + 4))
            }
        }
    }
}
func Eraser(isFull:Bool) -> some View {
    Image(isFull ? "EraserBack2" : "EraserBack")
        .resizable()
        .scaledToFit()
        .frame(width: 19, height: 90)
        .compositingGroup()
        .shadow(color: .gray.opacity(0.5),radius: 3, x: 0, y: 4)
}
func Lasso() -> some View {
    Image("LassoBack")
        .resizable()
        .scaledToFit()
        .frame(width: 19, height: 90)
        .compositingGroup()
        .shadow(color: .gray.opacity(0.5),radius: 3, x: 0, y: 4)
}
func Ruler() -> some View {
    Image("ruler")
        .resizable()
        .scaledToFit()
        .frame(width: 31, height: 90)
        .compositingGroup()
        .shadow(color: .gray.opacity(0.5),radius: 3, x: 0, y: 4)
}

struct ItemWidthSetting: View {
    @Binding var Width:CGFloat
    @Binding var color:CodableColor
    
    let widthin:ClosedRange<CGFloat>
    
    let width1:Double
    let width2:Double
    let width3:Double
    let width4:Double
    let width5:Double
    
    let type:String
    var body: some View {
        VStack {
            HStack {
                Text("笔画宽度")
                    .bold()
                Spacer()
                Text(String(Double(Width).roundTo(places: 2)) + "像素")
                    .bold()
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .padding([.leading, .trailing], 16)
            
            Slider(value: $Width, in: widthin)
                .padding([.leading, .trailing], 8)
            Divider()
            
            Group {
                if type == "Pen" {
                    HStack {
                        Pen(color: color, Width: width1, alpha: 1)
                            .offset(y: Width == width1 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width1
                                }
                            }
                        Pen(color: color, Width: width2, alpha: 1)
                            .offset(y: Width == width2 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width2
                                }
                            }
                        Pen(color: color, Width: width3, alpha: 1)
                            .offset(y: Width == width3 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width3
                                }
                            }
                        Pen(color: color, Width: width4, alpha: 1)
                            .offset(y: Width == width4 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width4
                                }
                            }
                        Pen(color: color, Width: width5, alpha: 1)
                            .offset(y: Width == width5 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width5
                                }
                            }
                    }
                    .animation(.spring(dampingFraction: 0.5).speed(2), value: Width)
                } else if type == "Pencil" {
                    HStack {
                        Pencil(color: color, Width: width1, alpha: 1)
                            .offset(y: Width == width1 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width1
                                }
                            }
                        Pencil(color: color, Width: width2, alpha: 1)
                            .offset(y: Width == width2 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width2
                                }
                            }
                        Pencil(color: color, Width: width3, alpha: 1)
                            .offset(y: Width == width3 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width3
                                }
                            }
                        Pencil(color: color, Width: width4, alpha: 1)
                            .offset(y: Width == width4 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width4
                                }
                            }
                        Pencil(color: color, Width: width5, alpha: 1)
                            .offset(y: Width == width5 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width5
                                }
                            }
                    }
                    .animation(.spring(dampingFraction: 0.5).speed(2), value: Width)
                } else if type == "Marker" {
                    HStack {
                        Marker(color: color, Width: width1, alpha: 1)
                            .offset(y: Width == width1 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width1
                                }
                            }
                        Marker(color: color, Width: width2, alpha: 1)
                            .offset(y: Width == width2 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width2
                                }
                            }
                        Marker(color: color, Width: width3, alpha: 1)
                            .offset(y: Width == width3 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width3
                                }
                            }
                        Marker(color: color, Width: width4, alpha: 1)
                            .offset(y: Width == width4 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width4
                                }
                            }
                        Marker(color: color, Width: width5, alpha: 1)
                            .offset(y: Width == width5 ? 20 : 30)
                            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .bottom)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    Width = width5
                                }
                            }
                    }
                    .animation(.spring(dampingFraction: 0.5).speed(2), value: Width)
                }
            }
            .clipShape(Rectangle())
        }
        .padding(.top, 15)
        .frame(width: 230)
    }
}



extension Double {
    
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))

        return (self * divisor).rounded() / divisor

    }

}
