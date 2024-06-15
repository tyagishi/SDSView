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

extension OSLog {
    // static fileprivate var log = Logger(subsystem: "com.smalldesksoftware.vanillaTextView", category: "ViewModel")
    static fileprivate var log = Logger(.disabled)
}

public protocol TextViewModelProtocol {
    var _textView: NSUITextView? { get set }
    var _scrollView: NSUIScrollView? { get set }
    var textChanged: AnyPublisher<String, Never> { get }
    var _textChanged: PassthroughSubject<String, Never> { get }
}

extension TextViewModelProtocol {
    public var textChanged: AnyPublisher<String, Never> { _textChanged.eraseToAnyPublisher() }
}

open class TextKitViewModel: NSObject, ObservableObject, TextViewModelProtocol {
    public var _textView: NSUITextView? = nil
    public var _scrollView: NSUIScrollView? = nil
    
    var textViewDelegate: NSUITextViewDelegate?
    
    public let _textChanged: PassthroughSubject<String, Never> = PassthroughSubject()
    
    var contentView: LayoutFragmentRootView = LayoutFragmentRootView()
    internal var fragmentViewMap: NSMapTable<NSTextLayoutFragment, TextLayoutFragmentView>

    public init(textViewDelegate: NSUITextViewDelegate? = nil) {
        self.textViewDelegate = textViewDelegate
        self.fragmentViewMap = .weakToWeakObjects()
    }
    
    public func forceLayout() {
        guard let textView = _textView,
              let textLayoutManager = textView.textLayoutManager else { return }
        textLayoutManager.textViewportLayoutController.layoutViewport()
    }
}

extension TextKitViewModel {
    public func textViewFactory(_ text: String) -> (NSUITextView, NSUIScrollView, NSUITextViewDelegate?) {
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
        
        // care cursor
        if #available(macOS 14, *) {
            let insertionIndicator = NSTextInsertionIndicator(frame: .zero)
            textView.addSubview(insertionIndicator)
        }
        
        textView.allowsUndo = true
        textView.textContainer?.size = NSSize(width: 0, height: 0) // 0 means no-limitation
        // note: textView.textContiner.lineFragmentPadding has 5.0 as default

        textView.textContentStorage?.delegate = self
        textView.textLayoutManager?.delegate = self
        textView.textLayoutManager?.textViewportLayoutController.delegate = self

        // MARK: build-up
        scrollView.documentView = textView
        self._textView = textView
        self._scrollView = scrollView
        
        textView.addSubview(contentView)

        return (textView, scrollView, nil)
        #else // for iOS
        let textView = UITextView(usingTextLayoutManager: true)
        textView.string = text
        textView.textContainer.size = CGSize(width: 0, height: 0)
        self._textView = textView
        textView.delegate = self

        textView.textContainerInset = .init(top: 0, left: 0, bottom: 0, right: 0)

        textView.textLayoutManager?.textContentManager?.delegate = self
        textView.textLayoutManager?.delegate = self
        textView.textLayoutManager?.textViewportLayoutController.delegate = self
        
        textView.addSubview(contentView)

        return (textView, textView, nil)
        #endif
    }
    
    public func textViewUpdate(textView: NSUITextView, scrollView: NSUIScrollView, text: String) -> Void {
        OSLog.log.debug(#function)
        guard let textView = _textView else { return }
        textView.needsLayout = true
        textView.needsDisplay = true
    }
}

final class LayoutFragmentRootView: NSUIView {
    #if os(macOS)
    override var isFlipped: Bool { return true }
    #endif
}
