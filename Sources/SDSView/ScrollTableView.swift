//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/04/17
//  © 2023  SmallDeskSoftware
//

import Foundation
import SwiftUI

#if os(macOS)
public typealias ScrollTableViewSetup = (NSTableView, NSScrollView) -> Void
public typealias ScrollTableViewUpdate = (NSTableView, NSScrollView) -> Void

public struct ScrollTableView: NSViewRepresentable {
    let tableSetup: ScrollTableViewSetup
    let tableUpdate: ScrollTableViewUpdate

    public init(tableSetup: @escaping ScrollTableViewSetup, tableUpdate: @escaping ScrollTableViewUpdate) {
        self.tableSetup = tableSetup
        self.tableUpdate = tableUpdate
    }

    public func makeNSView(context: Context) -> NSViewType {
        let scrollView = NSScrollView()
        let tableView = SpaceCapableTableView()

        tableSetup(tableView, scrollView)
        scrollView.documentView = tableView

        return scrollView
    }

    public func updateNSView(_ scrollView: NSViewType, context: Context) {
        guard let tableView = scrollView.documentView as? NSTableView else { return }
        tableUpdate(tableView, scrollView)
    }

    public typealias NSViewType = NSScrollView
}

public protocol SpaceCapableTableViewDelegate: NSTableViewDelegate {
    var spacePressed: ((NSEvent) -> Bool)? { get }
}

final public class SpaceCapableTableView: NSTableView {
    override public func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.keyCode == 49,
           let delegate = self.delegate as? SpaceCapableTableViewDelegate,
           let spacePressed = delegate.spacePressed {
            return spacePressed(event)
        }
        return super.performKeyEquivalent(with: event)
    }
}
#endif
