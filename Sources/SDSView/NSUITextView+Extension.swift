//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/08/14
//  © 2023  SmallDeskSoftware
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
    func nsuiTextDidChange(_ textView: NSUITextView)
}
#else
public protocol NSUITextViewDelegate: UITextViewDelegate {
    func nsuiTextDidChange(_ textView: NSUITextView)
}
#endif

extension NSUITextView {
    public var nsuiTextStorage: NSTextStorage {
        #if os(macOS)
        if let textStorage = self.textStorage { return textStorage }
        fatalError("textStorage is nil")
        #elseif os(iOS)
        return self.textStorage
        #endif
    }

    #if os(iOS)
    public var string: String {
        get {
            return self.text
        }
        set(newValue) {
            self.text = newValue
        }
    }
    public var needsLayout: Bool {
        get {
            true
        }
        set(newValue) {
            //
        }
    }
    public var needsDisplay: Bool {
        get {
            true
        }
        set(newValue) {
            //
        }
    }
    #endif

    public var nsuiSelectedLocation: Int? {
        #if os(macOS)
        if let selectedRange = self.selectedRanges.first?.rangeValue {
            return (selectedRange as NSRange).location
        }
        return nil
        #elseif os(iOS)
        return self.selectedRange.location
        #endif
    }

    public var nsuiSelectedRange: NSRange? {
        get {
            #if os(macOS)
            self.selectedRanges.first?.rangeValue
            #elseif os(iOS)
            self.selectedRange
            #endif
        }
        set(newValue) {
            #if os(macOS)
            if let newValue {
                self.setSelectedRange(newValue)
            }
            #elseif os(iOS)
            if let newValue {
                self.selectedRange = newValue
            }
            #endif
        }
    }

    public func nsuiInsertText(_ text: String, replacementRange range: NSRange) {
        #if os(macOS)
        self.insertText(text, replacementRange: range)
        #elseif os(iOS)
        fatalError("not implemented")
        #endif
    }
}