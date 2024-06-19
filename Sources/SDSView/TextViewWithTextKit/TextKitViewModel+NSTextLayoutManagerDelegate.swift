//
//  TextKitViewModel+NSTextLayoutManagerDelegate.swift
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
    // fileprivate static var log = Logger(subsystem: "com.smalldesksoftware.vanillaTextView", category: "TextKitViewModel: NSTextLayoutManagerDelegate")
    fileprivate static var log = Logger(.disabled)
}

#if false // use this as template
extension TextKitViewModel: NSTextLayoutManagerDelegate {
    public func textLayoutManager(_ textLayoutManager: NSTextLayoutManager,
                                  textLayoutFragmentFor location: any NSTextLocation,
                                  in textElement: NSTextElement) -> NSTextLayoutFragment {
        OSLog.log.debug("textLayoutFragmentFor: \(textElement.attrString?.string ?? "no-text")")
        return NSTextLayoutFragment(textElement: textElement, range: nil)
    }
}
#endif
