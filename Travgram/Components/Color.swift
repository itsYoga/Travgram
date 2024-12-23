//
//  Color.swift
//  Travgram
//
//  Created by Jesse Liang on 2024/12/24.
//

import SwiftUI

extension Color {
    init?(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = hex.hasPrefix("#") ? 1 : 0
        var rgbValue: UInt64 = 0
        if scanner.scanHexInt64(&rgbValue) {
            let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgbValue & 0x0000FF) / 255.0
            self = Color(red: red, green: green, blue: blue)
            return
        }
        return nil
    }

    func toHex() -> String {
        let components = UIColor(self).cgColor.components
        let r = Int((components?[0] ?? 0) * 255.0)
        let g = Int((components?[1] ?? 0) * 255.0)
        let b = Int((components?[2] ?? 0) * 255.0)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
