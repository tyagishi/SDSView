//
//  AttributedText.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/29
//  © 2023  SmallDeskSoftware
//

import Foundation
import SwiftUI

public struct AttributedText: NSViewRepresentable {
    let attributedString: NSAttributedString

    public init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    public func makeNSView(context: NSViewRepresentableContext<AttributedText>) -> NSTextField {
        let textField = NSTextField(labelWithAttributedString: attributedString)
        textField.isEditable = false
        textField.isSelectable = false
        textField.drawsBackground = true
        textField.backgroundColor = NSColor.clear
        return textField
    }

    public func updateNSView(_ nsView: NSTextField, context: NSViewRepresentableContext<AttributedText>) {
        nsView.attributedStringValue = self.attributedString
    }

    public typealias NSViewType = NSTextField
}
