//
//  varroot.swift
//  noteX
//
//  Created by 张旭晟 on 2022/11/6.
//

import Foundation
import PencilKit
import SwiftUI

class rootvar: ObservableObject {
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
