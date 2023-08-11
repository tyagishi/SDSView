//
//  ScrollTextView.swift
//
//  Created by : Tomoaki Yagishita on 2023/04/17
//  © 2023  SmallDeskSoftware
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

import SwiftUI
import SDSNSUIBridge

// at iOS, NSUIScrollView will be ignored/ at macOS NSUITextView will be ignored
public typealias ScrollTextViewFactory = @MainActor () -> (NSUITextView, NSUIScrollView)
//public typealias ScrollTextViewSetup = @MainActor (NSUITextView, NSUIScrollView) -> Void
public typealias ScrollTextViewUpdate = @MainActor (NSUITextView, NSUIScrollView) -> Void

#if os(macOS)
import AppKit
public typealias NSUITextView = NSTextView
public typealias EditActions = NSTextStorageEditActions
public typealias NSUIEditActions = NSTextStorageEditActions
public protocol NSUITextViewDelegate: NSTextViewDelegate {
    func nsuiTextDidChange(_ textView: NSUITextView)
}
#elseif os(iOS)
import UIKit
public typealias NSUITextView = UITextView
public typealias EditActions = NSTextStorage.EditActions
public typealias NSUIEditActions = NSTextStorage.EditActions
public protocol NSUITextViewDelegate: UITextViewDelegate {
    func nsuiTextDidChange(_ textView: NSUITextView)
}
#endif
#if os(macOS)
public struct ScrollTextView: NSViewRepresentable {
    let textViewFactory: ScrollTextViewFactory
    //let textViewSetup: ScrollTextViewSetup
    let textViewUpdate: ScrollTextViewUpdate

    public init(textViewFactory: @escaping ScrollTextViewFactory,
                //textViewSetup: @escaping ScrollTextViewSetup,
                textViewUpdate: @escaping ScrollTextViewUpdate) {
        self.textViewFactory = textViewFactory
        //self.textViewSetup = textViewSetup
        self.textViewUpdate = textViewUpdate
    }

    @MainActor
    public func makeNSView(context: Context) -> NSViewType {
        let (_, scrollView) = textViewFactory()
        //textViewSetup(textView, scrollView)
        return scrollView
    }

    @MainActor
    public func updateNSView(_ scrollView: NSViewType, context: Context) {
        guard let textView = scrollView.documentView as? NSUITextView else { return }
        textViewUpdate(textView, scrollView)
    }

    public typealias NSViewType = NSScrollView
}
#elseif os(iOS)
public struct ScrollTextView: UIViewRepresentable {
    public typealias UIViewType = UITextView

    let textViewFactory: ScrollTextViewFactory
    //let textViewSetup: ScrollTextViewSetup
    let textViewUpdate: ScrollTextViewUpdate

    public init(textViewFactory: @escaping ScrollTextViewFactory,
                //textViewSetup: @escaping ScrollTextViewSetup,
                textViewUpdate: @escaping ScrollTextViewUpdate) {
        self.textViewFactory = textViewFactory
        //self.textViewSetup = textViewSetup
        self.textViewUpdate = textViewUpdate
    }

    @MainActor
    public func makeUIView(context: Context) -> UIViewType {
        let (textView, _) = textViewFactory()
        //textViewSetup(textView, scrollView)
        return textView
    }

    @MainActor
    public func updateUIView(_ textView: UIViewType, context: Context) {
        textViewUpdate(textView, textView)
    }

}
#endif

