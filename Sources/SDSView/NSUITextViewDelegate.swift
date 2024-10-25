//
//  NSUITextViewDelegate.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/25
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

#if os(macOS)
public protocol NSUITextViewDelegate: NSTextViewDelegate {
    @MainActor
    func nsuiTextDidChange(_ textView: NSUITextView)
}
#else
public protocol NSUITextViewDelegate: UITextViewDelegate {
    @MainActor
    func nsuiTextDidChange(_ textView: NSUITextView)
}
#endif
