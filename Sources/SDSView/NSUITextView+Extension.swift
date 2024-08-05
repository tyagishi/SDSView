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
    @MainActor
    func nsuiTextDidChange(_ textView: NSUITextView)
}
#else
public protocol NSUITextViewDelegate: UITextViewDelegate {
    @MainActor
    func nsuiTextDidChange(_ textView: NSUITextView)
}
#endif

extension NSUITextView {
    public var nsuiTextContentStorage: NSTextContentStorage? {
        #if os(macOS)
        return self.textContentStorage
        #else // os(iOS)
        return self.textLayoutManager?.textContentManager as? NSTextContentStorage
        #endif
    }
    
    public var nsuiTextStorage: NSTextStorage {
        #if os(macOS)
        if let textStorage = self.textStorage { return textStorage }
        fatalError("textStorage is nil")
        #elseif os(iOS)
        return self.textStorage
        #endif
    }

    #if os(macOS)
    var text: String {
        self.string
    }
    #endif

    #if os(iOS)
    public var string: String {
        get {
            return self.text
        }
        set(newValue) {
            self.text = newValue
        }
    }
    #endif

    public var nsuiSelectedLocation: Int {
        #if os(macOS)
        return self.selectedRange().location
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
    
    /// insert text at specified position
    /// - Parameters:
    ///   - text: text to insert
    ///   - range: position/range for text, iff == nil, insert at current cursor position
    ///   note: NSText.insertText is deprecated mcOS 10.11
    public func nsuiInsertText(_ text: String, replacementRange range: NSRange? = nil) {
        #if os(macOS)
        let range = range ?? self.selectedRange()
        self.insertText(text, replacementRange: range)
        #elseif os(iOS)
        if let range = range {
            self.nsuiSelectedRange = range
        }
        self.insertText(text)
        #endif
    }
    
    public func nsuiHasMarkedText() -> Bool {
        #if os(macOS)
        return hasMarkedText()
        #else
        return markedTextRange != nil
        #endif
    }
    
    // setFrameSize (exist only on macOS)
    public func setNSUIFrameSize(_ size: CGSize) {
        #if os(macOS)
        setFrameSize(size)
        #else
        self.contentSize = size
        #endif
    }
}
