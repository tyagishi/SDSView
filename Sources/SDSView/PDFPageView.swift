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
    //let displayDirection: PDFDisplayDirection
    let autoScales: Bool

    public init(displayMode: PDFDisplayMode,
                //displayDirection: PDFDisplayDirection,
                autoScales: Bool) {
        self.displayMode = displayMode
        //self.displayDirection = displayDirection
        self.autoScales = autoScales
    }
}

public struct PDFPageView: View {
    let pdfDocument: PDFDocument
    @State private var currentPage: Int
    let config: PDFPageViewConfig

    public init(pdfDocument: PDFDocument,
                config: PDFPageViewConfig,
                startPage: Int? = 0) {
        self.pdfDocument = pdfDocument
        self.currentPage = startPage ?? 0
        self.config = config
    }
    
    public var body: some View {
        ZStack {
            HStack {
                let pageCount = pdfDocument.pageCount
                Spacer()
                Button(action: {
                    currentPage -= 1
                }, label: { Image(systemName: "arrow.backward.circle")})
                .buttonStyle(.borderless)
                .disabled(currentPage == 0)
                //.keyboardShortcut(.upArrow, modifiers: [])
                .keyboardShortcut(.leftArrow, modifiers: [])
                Text("\(currentPage)/\(pageCount-1)")
                Button(action: {
                    currentPage += 1
                }, label: { Image(systemName: "arrow.forward.circle")})
                .buttonStyle(.borderless)
                .disabled((pageCount-1) <= currentPage )
                //.keyboardShortcut(.downArrow, modifiers: [])
                .keyboardShortcut(.rightArrow, modifiers: [])
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing).zIndex(1)
            WrappedPDFView(doc: pdfDocument, page: $currentPage, config: config)
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name.PDFViewPageChanged, object: nil),
                           perform: { change in
                    guard let pdfView = change.object as? PDFView,
                          let document = pdfView.document,
                          let newCurrentPage = pdfView.currentPage else { return }
                    let newPageIndex = document.index(for: newCurrentPage)
                    self.currentPage = newPageIndex
                })
        }
    }
}

#if os(macOS)
public struct WrappedPDFView: NSViewRepresentable {
    public typealias NSViewType = PDFView
    let pdfDocument: PDFDocument
    @Binding var page: Int
    let config: PDFPageViewConfig?
    
    public init(doc pdfDocument: PDFDocument,
                page: Binding<Int>,
                config: PDFPageViewConfig? = nil) {
        self.pdfDocument = pdfDocument
        self._page = page
        self.config = config
    }

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
        if let targetPage = pdfView.document?.page(at: page),
           pdfView.currentPage != targetPage {
            pdfView.go(to: targetPage)
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
public struct WrappedPDFView: UIViewRepresentable {
    public typealias UIViewType = PDFView
    let pdfDocument: PDFDocument
    @Binding var page: Int
    let config: PDFPageViewConfig?
    
    public init(doc pdfDocument: PDFDocument,
                page: Binding<Int>,
                config: PDFPageViewConfig? = nil) {
        self.pdfDocument = pdfDocument
        self._page = page
        self.config = config
    }

    @MainActor
    public func makeUIView(context: Context) -> UIViewType {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        applyConfig(pdfView)
        return pdfView
    }
    
    @MainActor
    public func updateUIView(_ pdfView: UIViewType, context: Context) {
        if pdfView.document != pdfDocument {
            pdfView.document = pdfDocument
            applyConfig(pdfView)
        }
        if let targetPage = pdfView.document?.page(at: page),
           pdfView.currentPage != targetPage {
            pdfView.go(to: targetPage)
        }
    }
    
    internal func applyConfig(_ pdfView: PDFView) {
        if let config = config {
            pdfView.displayMode = config.displayMode
            pdfView.autoScales = config.autoScales
        }
    }
}
#endif
