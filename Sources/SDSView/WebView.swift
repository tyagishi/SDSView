//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/05/11
//  © 2023  SmallDeskSoftware
//

import Foundation
import WebKit
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import SwiftUI

public typealias WebViewSetup = (WKWebView) -> Void
public typealias WebViewUpdate = (WKWebView) -> Void

#if os(macOS)
public struct WebView: NSViewRepresentable {
    public typealias NSViewType = WKWebView

    let wkWebView: WKWebView
    let webviewSetup: WebViewSetup
    let webviewUpdate: WebViewUpdate

    public init(wkWebView: WKWebView? = nil,
                webviewSetup: @escaping WebViewSetup, webviewUpdate: @escaping WebViewUpdate) {
        self.webviewSetup = webviewSetup
        self.webviewUpdate = webviewUpdate
        self.wkWebView = wkWebView ?? WKWebView()
    }

    public func makeNSView(context: Context) -> WKWebView {
        webviewSetup(self.wkWebView)
        return wkWebView
    }
    
    public func updateNSView(_ nsView: WKWebView, context: Context) {
        webviewUpdate(nsView)
    }
}
#elseif os(iOS)
#warning("WebView for iOS is not implemented yet")
#endif
