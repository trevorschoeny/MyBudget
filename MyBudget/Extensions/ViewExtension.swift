//
//  ViewExtension.swift
//  MyBudget
//
//  Created by Trevor Schoeny on 6/8/21.
//

import Foundation
import SwiftUI

struct RefreshOnAppearModifier<Tag: Hashable>: ViewModifier {
    @State private var viewId = UUID()
    @Binding var selection: Tag?
    
    func body(content: Content) -> some View {
        content
            .id(viewId)
            .onAppear {
                if selection != nil {
                    viewId = UUID()
                    selection = nil
                }
            }
    }
}

extension View {
    func refreshOnAppear<Tag: Hashable>(selection: Binding<Tag?>? = nil) -> some View {
        modifier(RefreshOnAppearModifier(selection: selection ?? .constant(nil)))
    }
}
