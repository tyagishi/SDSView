//
//  PDFPageView.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/31
//  © 2024  SmallDeskSoftware
//

import SwiftUI

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

import SDSNSUIBridge
import PDFKit

#if os(macOS)
#elseif os(iOS)
#endif

public struct PDFPageViewConfig {
    let displayMode: PDFDisplayMode
    let autoScales: Bool
    public init(displayMode: PDFDisplayMode, autoScales: Bool) {
        self.displayMode = displayMode
        self.autoScales = autoScales
    }
}

#if os(macOS)
public struct PDFPageView: NSViewRepresentable {
    public typealias NSViewType = PDFView
    //public typealias Coordinator = TextKitTextViewDelegate

    let pdfDocument: PDFDocument
    let config: PDFPageViewConfig?
    
    public init(doc pdfDocument: PDFDocument, config: PDFPageViewConfig? = nil) {
        self.pdfDocument = pdfDocument
        self.config = config
    }
    
//    public func makeCoordinator() -> TextKitTextViewDelegate {
//        return TextKitTextViewDelegate($text)
//    }

    @MainActor
    public func makeNSView(context: Context) -> NSViewType {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        applyConfig(pdfView)
        return pdfView
    }
    
    @MainActor
    public func updateNSView(_ pdfView: NSViewType, context: Context) {
        if pdfView.document != pdfDocument {
            pdfView.document = pdfDocument
            applyConfig(pdfView)
        }
    }
    
    internal func applyConfig(_ pdfView: PDFView) {
        if let config = config {
            pdfView.displayMode = config.displayMode
            pdfView.autoScales = config.autoScales
        }
    }
}
#elseif os(iOS)
public struct PDFPageView: UIViewRepresentable {
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
        let (textView, _, localDelegate) = textViewFactory(text)
        context.coordinator.textViewDelegate = localDelegate
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


