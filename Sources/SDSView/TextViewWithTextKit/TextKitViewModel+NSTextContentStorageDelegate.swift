//
//  TextKitViewModel+NSTextContentStorageDelegate.swift
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
    // static fileprivate var log = Logger(subsystem: "com.smalldesksoftware.vanillaTextView", category: "TextKitViewModel: NSTextContentStorageDelegate")
    static fileprivate var log = Logger(.disabled)
}

extension TextKitViewModel: NSTextContentStorageDelegate {
    public func textContentStorage(_ textContentStorage: NSTextContentStorage,
                                   textParagraphWith range: NSRange) -> NSTextParagraph? {
        return nil
    }
}
