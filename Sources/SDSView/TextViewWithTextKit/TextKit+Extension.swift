//
//  TextKit+Extension.swift
//
//  Created by : Tomoaki Yagishita on 2024/06/14
//  © 2024  SmallDeskSoftware
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension NSTextElement {
    var attrString: NSAttributedString? {
        guard let textContentStorage = textContentManager as? NSTextContentStorage,
              let attrString = textContentStorage.attributedString(for: self) else { return nil }
        return attrString
    }
}

extension NSTextLayoutFragment {
    var attrString: NSAttributedString? {
        guard let textElement = textElement,
              let textContentStorage = textElement.textContentManager as? NSTextContentStorage,
              let attrString = textContentStorage.attributedString(for: textElement) else { return nil }
        return attrString
    }
}
