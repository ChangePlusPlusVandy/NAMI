//
//  TabVisibilityControls.swift
//  NAMI
//
//  Created by Zachary Tao on 12/3/24.
//

import SwiftUI

@Observable class TabsControl {
    private(set) var isTabVisible = true
    func makeVisible() {
        withAnimation(.snappy) {
            isTabVisible = true
        }
    }

    func makeHidden() {
        withAnimation(.snappy) {
            isTabVisible = false
        }
    }

    func makeVisibleNoAnimation() {
        isTabVisible = true
    }

    func makeHiddenNoAnimation() {
        isTabVisible = false
    }
}
