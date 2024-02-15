//
//  ColorPicker.swift
//  CSVCharts
//
//  Created by Anton on 15.02.24.
//

import SwiftUI

enum ColorPickerType {
    case chartColor
    case chartBackgroundColor
}

enum ColorOption: String, CaseIterable {
    case green
    case blue
    case yellow
    
    var name: String {
        return rawValue.capitalized
    }
    
    var color: Color {
        switch self {
        case .green:
            return .green
        case .blue:
            return .blue
        case .yellow:
            return .yellow
        }
    }
}
