//
//  TextKitViewModel+NSUITextViewDelegate.swift
//
//  Created by : Tomoaki Yagishita on 2024/06/14
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSNSUIBridge

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import OSLog

extension OSLog {
    // fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.sdsview", category: "NSUITextViewDelegate")
    fileprivate static var log = Logger(.disabled)
}

extension TextKitViewModel: NSUITextViewDelegate {
    public func nsuiTextDidChange(_ textView: SDSView.NSUITextView) {
        _textChanged.send(textView.string)
        #if os(iOS)
        self.forceLayout() // workaround for bug in TextKit2(layout will not be called in some cases...)
        #endif
    }
    #if os(macOS)
    // MARK: NSTextDelegate
    @available(macOS 10.10, *)
    @MainActor
    open func textDidChange(_ notification: Notification) {
        guard let textView = _textView else { return }
        //textViewDelegate?.textDidChange?(notification)
        nsuiTextDidChange(textView)
    }
    #else
    // MARK: UITextDelegate
    open func textViewDidChange(_ textView: UITextView) {
        textViewDelegate?.textViewDidChange?(textView)
        nsuiTextDidChange(textView)
    }
    #endif
}
