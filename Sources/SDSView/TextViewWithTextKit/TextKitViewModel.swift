//
//  VanillaTextViewModel.swift
//
//  Created by : Tomoaki Yagishita on 2024/06/11
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSNSUIBridge
import Combine
#if os(macOS)
import AppKit
#else
import UIKit
#endif
import OSLog

private var module = "com.smalldesksoftware.sdsview"

extension OSLog {
    // fileprivate static var log = Logger(subsystem: module, category: "TextKitViewModel")
    fileprivate static let log = Logger(.disabled)
}

public protocol TextViewModelProtocol {
    // swiftlint:disable identifier_name
    var _textView: NSUITextView? { get set }
    var _scrollView: NSUIScrollView? { get set }
    var textChanged: AnyPublisher<String, Never> { get }
    var _textChanged: PassthroughSubject<String, Never> { get }
    // swiftlint:enable identifier_name
}

extension TextViewModelProtocol {
    public var textChanged: AnyPublisher<String, Never> { _textChanged.eraseToAnyPublisher() }
}

/// viewModel for wrapped TextView
/// responsibility: changes in NSUITextView will be notified via textChanged publisher
///                 provide default implementation for textViewFactory, textViewUpdate
open class TextKitViewModel: NSObject, ObservableObject, TextViewModelProtocol {
    // swiftlint:disable identifier_name
    public var _textView: NSUITextView? = nil
    public var _scrollView: NSUIScrollView? = nil
    public let _textChanged: PassthroughSubject<String, Never> = PassthroughSubject()
    // swiftlint:enable identifier_name
    
    public var dic: [String: Any] = [:]

    override public init() {
    }
    
    @MainActor
    public func forceLayout() {
        guard let textView = _textView,
              let textStorage = textView.textStorage,
              let textLayoutManager = textView.textLayoutManager else { return }
        OSLog.log.debug("force to re-layout")
        textStorage.edited(.editedAttributes, range: NSRange(location: 0, length: (textView.string as NSString).length), changeInLength: 0)
        textLayoutManager.textViewportLayoutController.layoutViewport()
    }

    open func textViewFactory(_ text: String) -> (NSUITextView, NSUIScrollView, NSUITextViewDelegate?) {
        #if os(macOS)
        // MARK: NSScrollView
        let scrollView = NSUIScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        
        // MARK: NSTextView
        let textView = NSTextView(frame: .zero)
        textView.autoresizingMask = [.height, .width]
        textView.delegate = self
        textView.string = text
        //textView.textColor = .darkGray
        //textView.backgroundColor = .white
        textView.usesAdaptiveColorMappingForDarkAppearance = true

        // care cursor
        if #available(macOS 14, *) {
            let insertionIndicator = NSTextInsertionIndicator(frame: .zero)
            textView.addSubview(insertionIndicator)
        }
        
        textView.allowsUndo = true
        textView.textContainer?.size = NSSize(width: 0, height: 0) // 0 means no-limitation
        // note: textView.textContiner.lineFragmentPadding has 5.0 as default

        // set delegate
        if let delegate = self as? NSTextContentStorageDelegate { textView.textContentStorage?.delegate = delegate }
        if let delegate = self as? NSTextLayoutManagerDelegate { textView.textLayoutManager?.delegate = delegate }
        if let delegate = self as? NSTextViewportLayoutControllerDelegate { textView.textLayoutManager?.textViewportLayoutController.delegate = delegate }

        // MARK: build-up
        scrollView.documentView = textView
        self._textView = textView
        self._scrollView = scrollView
        
        return (textView, scrollView, self)
        #else // for iOS
        let textView = UITextView(usingTextLayoutManager: true)
        textView.string = text
        textView.textContainer.size = .zero
        self._textView = textView
        textView.delegate = self

        //textView.textColor = .darkGray
        //textView.backgroundColor = .white
        //textView.overrideUserInterfaceStyle = .dark
        
        textView.textContainerInset = .init(top: 0, left: 0, bottom: 0, right: 0)

        if let delegate = self as? NSTextContentStorageDelegate { textView.textLayoutManager?.textContentManager?.delegate = delegate }
        if let delegate = self as? NSTextLayoutManagerDelegate { textView.textLayoutManager?.delegate = delegate }
        if let delegate = self as? NSTextViewportLayoutControllerDelegate { textView.textLayoutManager?.textViewportLayoutController.delegate = delegate }

        return (textView, textView, self)
        #endif
    }
    
    open func textViewUpdate(textView: NSUITextView, scrollView: NSUIScrollView, text: String) {
        OSLog.log.debug(#function)
        guard let textView = _textView else { return }
        //textView.string = text
        textView.needsLayout = true
        textView.needsDisplay = true
    }
}
