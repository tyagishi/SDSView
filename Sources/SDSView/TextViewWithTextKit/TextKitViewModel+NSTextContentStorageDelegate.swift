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
    // fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.vanillaTextView", category: "TextKitViewModel+NSTextContentManagerDelegate")
    fileprivate static var log = Logger(.disabled)
}

#if false // use this as template
extension TextKitViewModel: NSTextContentManagerDelegate {
    public func textContentManager(_ textContentManager: NSTextContentManager,
                                   textElementAt location: any NSTextLocation) -> NSTextElement? {
        return nil
    }
    public func textContentManager(_ textContentManager: NSTextContentManager,
                                   shouldEnumerate textElement: NSTextElement, options: NSTextContentManager.EnumerationOptions = []) -> Bool {
        // basically enumerate all
        return true
    }
}
extension TextKitViewModel: NSTextContentStorageDelegate {
    public func textContentStorage(_ textContentStorage: NSTextContentStorage,
                                   textParagraphWith range: NSRange) -> NSTextParagraph? {
        return nil
    }
}
#endif
