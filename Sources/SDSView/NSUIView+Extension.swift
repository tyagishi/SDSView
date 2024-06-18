//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/06/12
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSNSUIBridge
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#else
#error("unsupported platform")
#endif

extension NSUIView {
    #if os(iOS)
    public var needsLayout: Bool {
        get {
            true
        }
        // swiftlint:disable:next unused_setter_value
        set(newValue) {
            setNeedsLayout()
        }
    }
    public var needsDisplay: Bool {
        get {
            true
        }
        // swiftlint:disable:next unused_setter_value
        set(newValue) {
            setNeedsDisplay()
        }
    }
    #endif
}
