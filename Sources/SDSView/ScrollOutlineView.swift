//
//  OutlineView.swift
//
//  Created by : Tomoaki Yagishita on 2023/02/12
//  © 2023  SmallDeskSoftware
//

import Foundation
import SwiftUI

#if os(macOS)
public typealias ScrollOutlineViewSetup = (NSOutlineView, NSScrollView) -> Void
public typealias ScrollOutlineViewUpdate = (NSOutlineView, NSScrollView) -> Void

public struct ScrollOutlineView: NSViewRepresentable {
    let outlineSetup: ScrollOutlineViewSetup
    let outlineUpdate: ScrollOutlineViewUpdate

    public init(outlineSetup: @escaping ScrollOutlineViewSetup, outlineUpdate: @escaping ScrollOutlineViewUpdate) {
        self.outlineSetup = outlineSetup
        self.outlineUpdate = outlineUpdate
    }

    public func makeNSView(context: Context) -> NSViewType {
        let scrollView = NSScrollView()
        let outlineView = NSOutlineView()

        outlineSetup(outlineView, scrollView)
        scrollView.documentView = outlineView

        return scrollView
    }

    public func updateNSView(_ scrollView: NSViewType, context: Context) {
        guard let outlineView = scrollView.documentView as? NSOutlineView else { return }
        outlineUpdate(outlineView, scrollView)
    }

    public typealias NSViewType = NSScrollView
}
#endif
