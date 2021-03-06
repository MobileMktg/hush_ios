//
//  Size.swift
//  Hush-SwiftUI
//
//  Created by Serge Vysotsky on 07.05.2020.
//  Copyright © 2020 AppServices. All rights reserved.
//

import SwiftUI

struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize?
    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = value ?? nextValue()
    }
}

struct SizeObserver: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content.background(GeometryReader { proxy in
            Color.clear.preference(key: SizeKey.self, value: proxy.size)
        }).onPreferenceChange(SizeKey.self) { size in
            self.size = size ?? .zero
        }
    }
}

extension View {
    func observeSize(_ size: Binding<CGSize>) -> some View {
        modifier(SizeObserver(size: size))
    }
}
