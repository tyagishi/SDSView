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
public typealias ScrollTextViewUpdate = @MainActor (NSUITextView, NSUIScrollView, String) -> Void

#if os(macOS)
import AppKit

public typealias NSUITextView = NSTextView
public typealias NSUIEditActions = NSTextStorageEditActions

@available(*, deprecated, renamed: "NSUIEditActions", message: "use NSUIEditActions")
public typealias EditActions = NSTextStorageEditActions

#elseif os(iOS)
import UIKit

public typealias NSUITextView = UITextView
public typealias NSUIEditActions = NSTextStorage.EditActions

@available(*, deprecated, renamed: "NSUIEditActions", message: "use NSUIEditActions")
public typealias EditActions = NSTextStorage.EditActions
#endif
#if os(macOS)
public struct ScrollTextView: NSViewRepresentable {
    public typealias NSViewType = NSScrollView
    public typealias Coordinator = TextKitTextViewDelegate
    @Binding var text: String
    let textViewFactory: ScrollTextViewFactory
    //let textViewSetup: ScrollTextViewSetup
    let textViewUpdate: ScrollTextViewUpdate

    public init(text: Binding<String>,
                textViewFactory: @escaping ScrollTextViewFactory,
                //textViewSetup: @escaping ScrollTextViewSetup,
                textViewUpdate: @escaping ScrollTextViewUpdate) {
        self._text = text
        self.textViewFactory = textViewFactory
        //self.textViewSetup = textViewSetup
        self.textViewUpdate = textViewUpdate
    }
    
    public func makeCoordinator() -> TextKitTextViewDelegate {
        return TextKitTextViewDelegate($text)
    }

    @MainActor
    public func makeNSView(context: Context) -> NSViewType {
        let (textView, scrollView) = textViewFactory()
        textView.delegate = context.coordinator
        //textViewSetup(textView, scrollView)
        return scrollView
    }
    
    @MainActor
    public func updateNSView(_ scrollView: NSViewType, context: Context) {
        guard let textView = scrollView.documentView as? NSUITextView else { return }
        textView.delegate = context.coordinator
        textViewUpdate(textView, scrollView, text)
    }
}
#elseif os(iOS)
public struct ScrollTextView: UIViewRepresentable {
    public typealias UIViewType = UITextView
    public typealias Coordinator = TextKitTextViewDelegate
    @Binding var text: String

    let textViewFactory: ScrollTextViewFactory
    //let textViewSetup: ScrollTextViewSetup
    let textViewUpdate: ScrollTextViewUpdate

    public init(text: Binding<String>,
                textViewFactory: @escaping ScrollTextViewFactory,
                //textViewSetup: @escaping ScrollTextViewSetup,
                textViewUpdate: @escaping ScrollTextViewUpdate) {
        self._text = text
        self.textViewFactory = textViewFactory
        //self.textViewSetup = textViewSetup
        self.textViewUpdate = textViewUpdate
    }

    public func makeCoordinator() -> TextKitTextViewDelegate {
        return TextKitTextViewDelegate($text)
    }

    @MainActor
    public func makeUIView(context: Context) -> UIViewType {
        let (textView, _) = textViewFactory()
        textView.delegate = context.coordinator
        //textViewSetup(textView, scrollView)
        return textView
    }

    @MainActor
    public func updateUIView(_ textView: UIViewType, context: Context) {
        textView.delegate = context.coordinator
        textViewUpdate(textView, textView, text)
    }
}
#endif

//public class TextKitTextViewDelegate: NSObject, NSUITextViewDelegate {
//    public func nsuiTextDidChange(_ textView: NSUITextView) {
//        print("Hello")
//    }
//}
