//
//  ScrollCollectionView.swift
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

#if os(macOS)
public typealias ScrollCollectionViewSetup = (NSCollectionView, NSScrollView) -> Void
public typealias ScrollCollectionViewUpdate = (NSCollectionView, NSScrollView) -> Void

public struct ScrollCollectionView: NSViewRepresentable {
    let collectionSetup: ScrollCollectionViewSetup
    let collectionUpdate: ScrollCollectionViewUpdate

    public init(collectionSetup: @escaping ScrollCollectionViewSetup, collectionUpdate: @escaping ScrollCollectionViewUpdate) {
        self.collectionSetup = collectionSetup
        self.collectionUpdate = collectionUpdate
    }

    public func makeNSView(context: Context) -> NSViewType {
        let scrollView = NSScrollView()
        let collectionView = NSCollectionView()

        collectionSetup(collectionView, scrollView)
        scrollView.documentView = collectionView

        return scrollView
    }

    public func updateNSView(_ scrollView: NSViewType, context: Context) {
        guard let collectionView = scrollView.documentView as? NSCollectionView else { return }
        collectionUpdate(collectionView, scrollView)
    }

    public typealias NSViewType = NSScrollView
}
#endif
