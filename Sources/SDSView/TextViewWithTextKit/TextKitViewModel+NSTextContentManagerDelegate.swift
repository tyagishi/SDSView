//
//  TextKitViewModel+NSTextContentManagerDelegate.swift
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
    // static fileprivate var log = Logger(subsystem: "com.smalldesksoftware.vanillaTextView", category: "TextKitViewModel: NSTextContentManagerDelegate")
    fileprivate static let log = Logger(.disabled)
}

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
