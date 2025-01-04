//
//  TGTextFieldModifier.swift
//  Travelgram
//
//  Created by Jesse Liang on 2024/12/22.
//

import SwiftUI
import Foundation

struct VGTextFieldModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 24)
    }
}
